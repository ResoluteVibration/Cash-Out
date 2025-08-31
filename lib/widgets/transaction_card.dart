import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../models/transaction.dart';
import '../providers/contact_provider.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final colors = userProvider.currentTheme.colorScheme;

    String byText;
    if (transaction.contactId == null || transaction.contactId!.isEmpty) {
      byText = "Self";
    } else {
      final contact = contactProvider.contacts.firstWhere(
            (c) => c.id == transaction.contactId,
        orElse: () => ContactModel(
          id: 'unknown',
          name: 'Unknown',
          amount: 0.0,
          type: 'Taken',
          when: DateTime.now(),
          settled: false,
          transactionId: 'unknown',
          userId: userProvider.currentUser?.id ?? '',
        ),
      );
      byText = contact.name;
    }

    // Format date
    final dateText = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.date);

    // Amount color
    final amountColor =
    transaction.type == 'Income' ? Colors.green : colors.error;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.description ?? 'No Description',
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'By: $byText',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateText,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          // Amount
          Text(
            (transaction.type == 'Income' ? '+' : '-') +
                '\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}