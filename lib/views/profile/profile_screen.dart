import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'manage_users_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Text(
                      user?.name.firstname.isNotEmpty == true
                          ? user!.name.firstname[0].toUpperCase()
                          : (user?.username.isNotEmpty == true ? user!.username[0].toUpperCase() : 'U'),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.name.fullName.isNotEmpty == true
                        ? user!.name.fullName
                        : (user?.username ?? 'Guest User'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'Sign in to access your account',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Profile Info Cards
            if (user != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline, color: AppColors.primary),
                      title: const Text('Username', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      subtitle: Text(user.username, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                      title: const Text('Phone', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      subtitle: Text(user.phone.isNotEmpty ? user.phone : 'Not set', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: AppColors.primary),
                      title: const Text('Address', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      subtitle: Text(user.address.fullAddress.isNotEmpty ? user.address.fullAddress : 'Not set', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Actions Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.group_outlined, color: AppColors.primary),
                    title: const Text('Manage Users (FakeStore API)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('View, add, edit, delete users'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primary),
                    title: const Text('About FakeStore App', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Built with Flutter & FakeStoreAPI'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'FakeStore E-Commerce',
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'Powered by FakeStoreAPI.com',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Login / Logout Button
            if (authProvider.isAuthenticated)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.1),
                  foregroundColor: AppColors.error,
                ),
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text('Sign In to Account'),
              ),
          ],
        ),
      ),
    );
  }
}
