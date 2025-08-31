import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final String? description;
  final DateTime date;
  final String mode;
  final String? category;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    this.description,
    required this.date,
    required this.mode,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
      'mode': mode,
      'category': category,
    };
  }

  factory TransactionModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'],
      type: data['type'],
      amount: (data['amount'] as num).toDouble(),
      description: data['description'],
      date: (data['date'] as Timestamp).toDate(),
      mode: data['mode'],
      category: data['category'],
    );
  }

  TransactionModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? description,
    DateTime? date,
    String? mode,
    String? category,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      mode: mode ?? this.mode,
      category: category ?? this.category,
    );
  }
}
