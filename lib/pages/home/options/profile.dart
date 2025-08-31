import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
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
                  title: 'Settings',
                  icon: Icons.settings,
                  colors: colors,
                  enabled: isLoggedIn,
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
                if (isLoggedIn) ...[

                  const SizedBox(height: 20),
                  _buildListItem(
                    context,
                    title: 'Change Password',
                    icon: Icons.lock,
                    colors: colors,
                    enabled: isLoggedIn,
                  ),

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
