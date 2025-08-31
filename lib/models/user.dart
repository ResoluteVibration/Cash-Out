import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final double amount; // new field

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    this.amount = 0.0, // default zero
  });

  /// From Firestore doc
  factory UserModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
    );
  }

  /// From Map (SharedPreferences)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'amount': amount,
    };
  }

  UserModel copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? email,
    String? password,
    double? amount,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      password: password ?? this.password,
      amount: amount ?? this.amount,
    );
  }
}
