import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/transaction_card.dart';
import 'options/got_money.dart';
import 'options/profile.dart';
import 'options/transaction_history.dart';
import 'options/spent_money.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget _buildBalanceCard(BuildContext context, ColorScheme colors) {
    final userProvider = Provider.of<UserProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final amount = userProvider.currentUser?.amount ?? 0.0;
    final todayNetChange = transactionProvider.getTodayNetChange;
    final todayChangeText = todayNetChange >= 0
        ? 'Today: +\₹${todayNetChange.toStringAsFixed(2)}'
        : 'Today: -\₹${todayNetChange.abs().toStringAsFixed(2)}';

    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You Still Have',
              style: TextStyle(color: colors.primaryContainer, fontSize: 16),
            ),
            const SizedBox(height: 3),
            Text(
              '\₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              todayChangeText,
              style: TextStyle(color: colors.secondaryContainer, fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(context, 'Got?', Icons.download, colors),
                _buildActionButton(context, 'Spent', Icons.upload, colors),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String text, IconData icon, ColorScheme colors) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton.icon(
        onPressed: () async {
          if (text == 'Got?') {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GotMoneyPage()),
            );
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SpentMoneyPage()),
            );
          }
        },
        icon: Icon(icon, color: colors.onPrimary),
        label: Text(text, style: TextStyle(color: colors.onPrimary)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, child) {
        final theme = userProvider.currentTheme;
        final colors = theme.colorScheme;
        final user = userProvider.currentUser;

        final greetingText = user != null
            ? 'Hi, ${user.firstname}'
            : 'Hi, Log Yourself to Start Tracking.';

        final initials = user != null
            ? '${user.firstname.isNotEmpty ? user.firstname[0] : ''}${user.lastname.isNotEmpty ? user.lastname[0] : ''}'.toUpperCase()
            : 'G';

        final recentTransactions = transactionProvider.transactions.take(5).toList();

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.surface,
            elevation: 8,
            shadowColor: colors.shadow.withOpacity(0.2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30.0),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: colors.surfaceVariant,
                child: Text(
                  initials,
                  style: TextStyle(color: colors.onPrimary),
                ),
              ),
            ),
            title: Text(
              greetingText,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.person, color: colors.onSurface),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildBalanceCard(context, colors),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
                        );
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: recentTransactions
                      .map((txn) => TransactionCard(transaction: txn))
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
