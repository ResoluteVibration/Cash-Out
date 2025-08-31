import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'dart:async';

class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _transactionSubscription;
  String? _userId;

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  TransactionProvider(BuildContext context) {
    _initStream(context);
  }

  void _initStream(BuildContext context) {
    _transactionSubscription?.cancel();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Listen to changes in the user and start/stop the stream accordingly
    userProvider.addListener(() {
      final newUserId = userProvider.currentUser?.id;
      if (newUserId != _userId) {
        _userId = newUserId;
        _listenToTransactions();
      }
    });

    _userId = userProvider.currentUser?.id;
    _listenToTransactions();
  }

  void _listenToTransactions() {
    _transactionSubscription?.cancel();
    if (_userId == null) {
      _transactions = [];
      notifyListeners();
      return;
    }

    _transactionSubscription = _db
        .collection('transactions')
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .listen((snapshot) {
      _transactions = snapshot.docs
          .map((doc) => TransactionModel.fromDoc(doc))
          .toList();

      // Sort the transactions by date in the app code
      _transactions.sort((a, b) => b.date.compareTo(a.date));

      notifyListeners();
    });
  }

  // 🔹 Add a Transaction
  Future<void> addTransaction(TransactionModel txn) async {
    if (_userId == null) return;
    await _db.collection('transactions').add(txn.toMap());
  }

  // 🔹 Delete a Transaction
  Future<void> deleteTransaction(String transactionId) async {
    if (_userId == null) return;
    await _db.collection('transactions').doc(transactionId).delete();
  }

  // 🔹 Clear all transactions for the current user
  Future<void> clearAllTransactions() async {
    if (_userId == null) {
      print('User ID is null. Cannot clear transactions.');
      return;
    }

    try {
      final batch = _db.batch();
      final transactionsQuery = _db
          .collection('transactions')
          .where('userId', isEqualTo: _userId);

      final querySnapshot = await transactionsQuery.get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      _transactions = [];
      notifyListeners();
      print('All transactions for user $_userId have been cleared.');
    } catch (e) {
      print('Error clearing transactions: $e');
    }
  }

  // 🔹 Delete transactions by a specific date range
  Future<void> deleteTransactionsByDateRange(DateTime startDate, DateTime endDate) async {
    if (_userId == null) {
      print('User ID is null. Cannot clear transactions.');
      return;
    }

    // Normalize dates to be at the start of the day and end of the day, respectively.
    final startOfDay = DateTime(startDate.year, startDate.month, startDate.day);
    final endOfDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    try {
      final batch = _db.batch();
      // Fetch all documents for the user and filter locally to avoid a composite index error.
      final transactionsQuery = _db.collection('transactions').where('userId', isEqualTo: _userId);

      final querySnapshot = await transactionsQuery.get();

      for (var doc in querySnapshot.docs) {
        final docDate = (doc['date'] as Timestamp).toDate();
        // Check if the transaction date is within the specified range (inclusive).
        if (docDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) && docDate.isBefore(endOfDay.add(const Duration(seconds: 1)))) {
          batch.delete(doc.reference);
        }
      }

      await batch.commit();

      // The stream will automatically handle updating the local list
      print('Transactions from $startOfDay to $endOfDay have been cleared for user $_userId.');
    } catch (e) {
      print('Error clearing transactions: $e');
    }
  }

  // 🔹 Get today's transactions
  List<TransactionModel> get getTodayTransactions {
    final today = DateTime.now();
    return _transactions.where((txn) {
      return txn.date.year == today.year &&
          txn.date.month == today.month &&
          txn.date.day == today.day;
    }).toList();
  }

  double get getTodayNetChange {
    final todayTxns = getTodayTransactions;
    double net = 0.0;
    for (var txn in todayTxns) {
      if (txn.type == 'Income') {
        net += txn.amount;
      } else {
        net -= txn.amount;
      }
    }
    return net;
  }

  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }
}
