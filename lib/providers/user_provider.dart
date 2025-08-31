import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../color schemes/blue.dart';
import '../models/user.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Always default to Blue theme
  final ThemeData _currentTheme = buildBlueTheme();
  ThemeData get currentTheme => _currentTheme;

  UserProvider() {
    _loadUserFromPrefs();
  }

  /// Login with email and password
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

  /// Register user with initial amount = 0
  Future<void> register(UserModel user) async {
    final docRef = _db.collection('users').doc();
    final newUser = user.copyWith(
      id: docRef.id,
      amount: 0.0,
    );

    await docRef.set(newUser.toMap());

    _currentUser = newUser;
    await _saveUserIdToPrefs(_currentUser!.id);
    notifyListeners();
  }

  /// Logout user
  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
    notifyListeners();
  }

  /// Set user directly (used after registration)
  Future<void> setUser(UserModel user) async {
    _currentUser = user;
    await _saveUserIdToPrefs(user.id);
    notifyListeners();
  }

  /// Update user's amount
  Future<void> updateAmount(double newAmount) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(amount: newAmount);
    notifyListeners();

    await _db.collection('users').doc(_currentUser!.id).update({
      'amount': newAmount,
    });
  }

  /// Save user ID to SharedPreferences for session persistence
  Future<void> _saveUserIdToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUserId', userId);
  }

  /// Load user from SharedPreferences on app start
  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('currentUserId');
    if (userId != null) {
      final userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        _currentUser = UserModel.fromDoc(userDoc);
        notifyListeners();
      } else {
        await prefs.remove('currentUserId');
      }
    }
  }
}
