import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String id;
  final String name;
  final String transactionId;
  final double amount;
  final DateTime when;
  final String type; // Taken or Lent
  final bool settled;
  final String userId; // New field added

  ContactModel({
    required this.id,
    required this.name,
    required this.transactionId,
    required this.amount,
    required this.when,
    required this.type,
    required this.settled,
    required this.userId, // New field added to the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'transactionId': transactionId,
      'amount': amount,
      'when': when,
      'type': type,
      'settled': settled,
      'userId': userId, // New field added to toMap
    };
  }

  factory ContactModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContactModel(
      id: doc.id,
      name: data['name'],
      transactionId: data['transactionId'],
      amount: (data['amount'] as num).toDouble(),
      when: (data['when'] as Timestamp).toDate(),
      type: data['type'],
      settled: data['settled'],
      userId: data['userId'] as String, // New field added to fromDoc
    );
  }
}