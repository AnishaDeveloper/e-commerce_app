import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'manage_users_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileDialog(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.currentUser;
    final firstNameController = TextEditingController(text: user?.name.firstname ?? '');
    final lastNameController = TextEditingController(text: user?.name.lastname ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');
    final cityController = TextEditingController(text: user?.address.city ?? '');
    final streetController = TextEditingController(text: user?.address.street ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2430),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDarkDialogField(firstNameController, 'First Name'),
              const SizedBox(height: 10),
              _buildDarkDialogField(lastNameController, 'Last Name'),
              const SizedBox(height: 10),
              _buildDarkDialogField(emailController, 'Email'),
              const SizedBox(height: 10),
              _buildDarkDialogField(phoneController, 'Phone'),
              const SizedBox(height: 10),
              _buildDarkDialogField(cityController, 'City'),
              const SizedBox(height: 10),
              _buildDarkDialogField(streetController, 'Street'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amazonOrange,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (user != null) {
                final updated = user.copyWith(
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                  name: Name(
                    firstname: firstNameController.text.trim(),
                    lastname: lastNameController.text.trim(),
                  ),
                  address: Address(
                    city: cityController.text.trim(),
                    street: streetController.text.trim(),
                    number: user.address.number,
                    zipcode: user.address.zipcode,
                  ),
                );
                authProvider.updateCurrentUser(updated);
              }
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            },
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static Widget _buildDarkDialogField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF131922),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade800)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade800)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.amazonOrange)),
      ),
    );
  }

  void _showSavedAddresses(BuildContext context, User? user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181F2B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saved Addresses', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF222B3A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.amazonOrange.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.amazonOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Default Shipping Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          user?.address.fullAddress.isNotEmpty == true ? user!.address.fullAddress : '12 5th Ave, New York (10001)',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppColors.discountGreen, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final userName = user?.name.firstname.isNotEmpty == true
        ? user!.name.firstname
        : (user?.username ?? 'Customer');

    // Dark theme background matching reference image
    const darkBgColor = Color(0xFF0F141C);
    const cardBgColor = Color(0xFF1A222F);

    return Scaffold(
      backgroundColor: darkBgColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          children: [
            // Top App Bar Header with Logo & Notification & Search
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/icons/app_logo.jpg',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    children: [
                      TextSpan(text: 'NOVA ', style: TextStyle(color: AppColors.amazonOrange)),
                      TextSpan(text: 'STORE', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const Spacer(),
                // Notification bell with badge (like in image)
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No new notifications')),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.dealRed,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: const Text(
                          '3',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),

            // User Profile Row (Avatar + "Hello, Navdeep" style)
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.amazonOrange.withValues(alpha: 0.2),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: AppColors.amazonOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hello, ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (user?.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user!.email,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 4 Grid Action Buttons (Your order, Wishlist, Coupons, Track order)
            Row(
              children: [
                Expanded(
                  child: _buildDarkActionButton(
                    title: 'Your order',
                    cardColor: cardBgColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orders synced with FakeStore API')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDarkActionButton(
                    title: 'Wishlist',
                    cardColor: cardBgColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wishlist: 5 items saved')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDarkActionButton(
                    title: 'Coupons',
                    cardColor: cardBgColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Active coupon: NOVA50 applied!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDarkActionButton(
                    title: 'Track order',
                    cardColor: cardBgColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order #8491: Out for delivery today')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Section 1: Account Settings
            const Text(
              'Account Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Edit profile',
              onTap: () => _showEditProfileDialog(context, authProvider),
            ),
            _buildMenuItem(
              icon: Icons.credit_card_outlined,
              title: 'Saved Cards & Wallet',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wallet balance: \$150.00')),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              onTap: () => _showSavedAddresses(context, user),
            ),
            _buildMenuItem(
              icon: Icons.language_outlined,
              title: 'Select Language',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Current language: English (US)')),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications Settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Push notifications are enabled')),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.manage_accounts_outlined,
              title: 'Manage Users (API)',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
                );
              },
            ),

            const SizedBox(height: 24),

            // Section 2: My Activity
            const Text(
              'My Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildMenuItem(
              icon: Icons.star_border,
              title: 'Reviews',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You have written 4 verified reviews')),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About App',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'NOVA Store',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Powered by FakeStoreAPI.com',
                );
              },
            ),

            const SizedBox(height: 28),

            // Log Out Button
            if (authProvider.isAuthenticated)
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22161A),
                    foregroundColor: AppColors.dealRed,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.dealRed.withValues(alpha: 0.3)),
                    ),
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
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              )
            else
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amazonOrange,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.login, size: 20),
                  label: const Text('Sign In to Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkActionButton({
    required String title,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        leading: Icon(icon, color: Colors.grey.shade400, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade600,
          size: 20,
        ),
      ),
    );
  }
}
