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
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      _transactions = snapshot.docs
          .map((doc) => TransactionModel.fromDoc(doc))
          .toList();
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
