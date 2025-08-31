import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../color schemes/blue.dart';
import '../color schemes/red.dart';
import '../color schemes/green.dart';
import '../color schemes/purple.dart';
import '../models/user.dart';
import '../models/enums.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  final ThemeData _currentTheme = buildRedTheme();
  ThemeData get currentTheme => _currentTheme;

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<bool> login(String email, String password) async {
    final q = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .limit(1)
        .get();

    if (q.docs.isNotEmpty) {
      _currentUser = UserModel.fromDoc(q.docs.first);
      await _saveUserIdToPrefs(_currentUser!.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> register(UserModel user) async {
    final docRef = _db.collection('users').doc();
    final newUser = user.copyWith(
      id: docRef.id,
      amount: 0.0, // Initial amount is 0
    );
    await docRef.set(newUser.toMap());
    _currentUser = newUser;
    await _saveUserIdToPrefs(newUser.id);
    notifyListeners();
  }

  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUserId');
    notifyListeners();
  }

  Future<void> setUser(UserModel user) async {
    _currentUser = user;
    await _saveUserIdToPrefs(user.id);
    notifyListeners();
  }

  Future<void> updateAmount(double newAmount) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(amount: newAmount);
    notifyListeners();
    await _db.collection('users').doc(_currentUser!.id).update({
      'amount': newAmount,
    });
  }

  Future<void> updateBalance(double amount, String transactionType) async {
    if (_currentUser == null) return;

    double newBalance = _currentUser!.amount;
    if (transactionType == TransactionType.Income.name) {
      newBalance += amount;
    } else if (transactionType == TransactionType.Expense.name) {
      newBalance -= amount;
    }

    await updateAmount(newBalance);
  }

  Future<void> updateUserPassword({required String oldPassword, required String newPassword}) async {
    if (_currentUser == null) return;

    if (oldPassword != _currentUser!.password) {
      throw Exception('Incorrect old password.');
    }

    await _db.collection('users').doc(_currentUser!.id).update({
      'password': newPassword,
    });
    // Update local user model
    _currentUser = _currentUser!.copyWith(password: newPassword);
    notifyListeners();
  }

  Future<void> updateUserProfile({
    String? firstname,
    String? lastname,
    String? email,
    double? amount,
    required String password, // 🔹 Added password parameter for validation
  }) async {
    if (_currentUser == null) return;

    // 🔹 Validate the password before proceeding with the update
    if (password != _currentUser!.password) {
      throw Exception('Incorrect password. Profile not updated.');
    }

    final updatedData = <String, dynamic>{};
    if (firstname != null) {
      updatedData['firstname'] = firstname;
    }
    if (lastname != null) {
      updatedData['lastname'] = lastname;
    }
    if (email != null && email.trim().isNotEmpty) {
      if (email != _currentUser!.email) {
        final existingUser = await _db
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (existingUser.docs.isNotEmpty) {
          throw Exception('Email already exists. Please use a different one.');
        }
      }
      updatedData['email'] = email;
    }
    if (amount != null) {
      updatedData['amount'] = amount;
    }

    if (updatedData.isNotEmpty) {
      await _db.collection('users').doc(_currentUser!.id).update(updatedData);

      // Update local user model
      _currentUser = _currentUser!.copyWith(
        firstname: firstname,
        lastname: lastname,
        email: email,
        amount: amount,
      );
      notifyListeners();
    }
  }

  Future<void> _saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUserId', userId);
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('currentUserId');
    if (userId != null) {
      final userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _currentUser = UserModel.fromDoc(userDoc);
        notifyListeners();
      }
    }
  }
}
