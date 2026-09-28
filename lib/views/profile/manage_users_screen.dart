import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  void _showAddEditUserDialog([User? user]) {
    final isEditing = user != null;
    final usernameController = TextEditingController(text: user?.username ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final firstNameController = TextEditingController(text: user?.name.firstname ?? '');
    final lastNameController = TextEditingController(text: user?.name.lastname ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');
    final cityController = TextEditingController(text: user?.address.city ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit User' : 'Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
            onPressed: () async {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final newUser = User(
                id: user?.id ?? 0,
                email: emailController.text.trim(),
                username: usernameController.text.trim(),
                password: user?.password ?? 'pass123',
                name: Name(
                  firstname: firstNameController.text.trim(),
                  lastname: lastNameController.text.trim(),
                ),
                phone: phoneController.text.trim(),
                address: Address(
                  city: cityController.text.trim(),
                  street: user?.address.street ?? 'Main St',
                  number: user?.address.number ?? 1,
                  zipcode: user?.address.zipcode ?? '10001',
                ),
              );

              Navigator.of(ctx).pop();
              if (isEditing) {
                await userProvider.updateUser(newUser);
              } else {
                await userProvider.addUser(newUser);
              }
            },
            child: Text(isEditing ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Add User',
            onPressed: () => _showAddEditUserDialog(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (userProvider.isLoading && userProvider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.errorMessage != null && userProvider.users.isEmpty) {
            return Center(child: Text(userProvider.errorMessage!));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: userProvider.users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = userProvider.users[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                      child: Text(
                        user.name.firstname.isNotEmpty
                            ? user.name.firstname[0].toUpperCase()
                            : user.username.isNotEmpty
                                ? user.username[0].toUpperCase()
                                : 'U',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name.fullName.isNotEmpty ? user.name.fullName : user.username,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          if (user.address.city.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              '📍 ${user.address.city}',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => _showAddEditUserDialog(user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                      onPressed: () => userProvider.deleteUser(user.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
