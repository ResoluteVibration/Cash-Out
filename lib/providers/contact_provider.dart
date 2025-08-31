import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact.dart';

class ContactProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ContactModel> _contacts = [];
  List<ContactModel> get contacts => _contacts;

  Future<void> addContact(ContactModel contact) async {
    await _db.collection('contacts').add(contact.toMap());
    fetchContacts(contact.userId);
  }

  Future<void> fetchContacts(String userId) async {
    final snapshot =
    await _db.collection('contacts').where('userId', isEqualTo: userId).orderBy('when', descending: true).get();
    _contacts =
        snapshot.docs.map((doc) => ContactModel.fromDoc(doc)).toList();
    notifyListeners();
  }

  Future<void> markContactSettled(String contactId, String userId) async {
    await _db.collection('contacts').doc(contactId).update({'settled': true});
    fetchContacts(userId);
  }
}