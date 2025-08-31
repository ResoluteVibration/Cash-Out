import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/contact_provider.dart';
import '../../widgets/transaction_card.dart';
import 'options/got_money.dart';
import 'options/profile.dart';
import 'bottom/transaction_history.dart';
import 'options/spent_money.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBalanceCard(BuildContext context, ColorScheme colors) {
    final userProvider = Provider.of<UserProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final amount = userProvider.currentUser?.amount ?? 0.0;
    final todayNetChange = transactionProvider.getTodayNetChange;
    final todayChangeText = todayNetChange >= 0
        ? 'Today: +\$${todayNetChange.toStringAsFixed(2)}'
        : 'Today: -\$${todayNetChange.abs().toStringAsFixed(2)}';

    return Container(
      height: 220,
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
            const SizedBox(height: 5),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: colors.onPrimary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              todayChangeText,
              style: TextStyle(color: colors.secondaryContainer, fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      width: 150,
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

  Widget _buildBottomBar(BuildContext context, ColorScheme colors) {
    return BottomNavigationBar(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) async {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 2) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 36),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, TransactionProvider>(
      builder: (context, userProvider, transactionProvider, child) {
        final theme = userProvider.currentTheme;
        final colors = theme.colorScheme;
        final user = userProvider.currentUser;

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
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'user-avatar',
                child: CircleAvatar(
                  backgroundColor: colors.surfaceVariant,
                  child: Text(
                    initials,
                    style: TextStyle(color: colors.onPrimary),
                  ),
                ),
              ),
            ),
            title: Text(
              'Main Wallet',
              style: TextStyle(color: colors.onSurface, fontSize: 18),
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
                Text(
                  'Recent Transactions',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: _buildBottomBar(context, colors),
          ),
        );
      },
    );
  }
}
