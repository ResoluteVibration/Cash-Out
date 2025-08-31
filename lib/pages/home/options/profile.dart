import 'package:cash_out/pages/profile/change_password.dart';
import 'package:cash_out/pages/profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../authentication/login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final colors = userProvider.currentTheme.colorScheme;
    final isLoggedIn = userProvider.isLoggedIn;
    final user = userProvider.currentUser;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: colors.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: colors.secondaryContainer,
                          child: isLoggedIn && user!.firstname.isNotEmpty
                              ? Text(
                            _getInitials(user.firstname, user.lastname),
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : Text(
                            'G',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLoggedIn
                                  ? '${user?.firstname} ${user?.lastname}'
                                  : 'Guest User',
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              isLoggedIn
                                  ? 'Welcome back!'
                                  : 'Login to access your profile',
                              style: TextStyle(
                                color: colors.onPrimaryContainer,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                _buildListItem(
                  context,
                  title: 'Clear Transaction History',
                  icon: Icons.auto_delete_outlined,
                  colors: colors,
                  enabled: isLoggedIn,
                  onTap: () => _showClearHistoryOptions(context),
                ),
                if (!isLoggedIn)
                  _buildListItem(
                    context,
                    title: 'Login',
                    icon: Icons.login,
                    colors: colors,
                    enabled: true,
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (isLoggedIn) ...[

                  _buildListItem(
                    context,
                    title: 'Update Profile',
                    icon: Icons.self_improvement,
                    colors: colors,
                    enabled: isLoggedIn,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UpdateProfilePage(),
                      ),
                    ),
                  ),

                  _buildListItem(
                    context,
                    title: 'Change Password',
                    icon: Icons.lock,
                    colors: colors,
                    enabled: isLoggedIn,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordPage(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildListItem(
                    context,
                    title: 'Logout',
                    icon: Icons.logout_rounded,
                    colors: colors,
                    enabled: true,
                    onTap: userProvider.signOut,
                  ),
                  const SizedBox(height: 20),]
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final transactionProvider = context.read<TransactionProvider>();
        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text('Clear History', style: TextStyle(color: colors.onSurface)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildClearOption(context, 'Today', () async {
                await transactionProvider.deleteTransactionsByDateRange(DateTime.now(), DateTime.now());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transactions for today cleared successfully!')),
                );
              }),
              _buildClearOption(context, 'This Week', () async {
                final now = DateTime.now();
                final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                final endOfWeek = startOfWeek.add(const Duration(days: 6));
                await transactionProvider.deleteTransactionsByDateRange(startOfWeek, endOfWeek);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transactions for this week cleared successfully!')),
                );
              }),
              _buildClearOption(context, 'This Month', () async {
                final now = DateTime.now();
                final startOfMonth = DateTime(now.year, now.month, 1);
                final endOfMonth = DateTime(now.year, now.month + 1, 0);
                await transactionProvider.deleteTransactionsByDateRange(startOfMonth, endOfMonth);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transactions for this month cleared successfully!')),
                );
              }),
              _buildClearOption(context, 'All Time', () async {
                await transactionProvider.clearAllTransactions();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All transactions cleared successfully!')),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: colors.primary)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClearOption(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      onTap: onTap,
    );
  }

  Widget _buildListItem(
      BuildContext context, {
        required String title,
        required IconData icon,
        required ColorScheme colors,
        required bool enabled,
        VoidCallback? onTap,
        Widget? trailingWidget,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: enabled ? colors.surface : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        leading: Icon(icon, color: colors.primary),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? colors.onSurface : colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailingWidget,
        onTap: enabled ? onTap : null,
      ),
    );
  }

  String _getInitials(String first, String last) {
    final firstInitial = first.isNotEmpty ? first[0] : '';
    final lastInitial = last.isNotEmpty ? last[0] : '';
    return '$firstInitial$lastInitial'.toUpperCase();
  }
}
