import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final adminUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(supabaseRepoProvider).adminFetchUsers();
});

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/dashboard'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminUsersProvider);
        },
        child: ResponsiveLayout(
          mobileBody: _buildMobileLayout(asyncUsers, ref),
          tabletBody: _buildTabletLayout(asyncUsers, ref),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_user_fab',
        onPressed: () => _showAddUserDialog(context, ref),
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileLayout(AsyncValue<List<Map<String, dynamic>>> asyncUsers, WidgetRef ref) {
    return asyncUsers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading users: $e')),
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text((user['full_name'] as String?)?.substring(0, 1).toUpperCase() ?? 'U'),
              ),
              title: Text(user['full_name'] ?? 'No name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['user_id'] ?? 'No ID'),
                  Text(user['role'] ?? 'No role'),
                  Text(user['phone'] ?? 'No phone'),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) => _handleUserAction(action, user, ref),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'change_role', child: Text('Change Role')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout(AsyncValue<List<Map<String, dynamic>>> asyncUsers, WidgetRef ref) {
    return asyncUsers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading users: $e')),
      data: (users) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Users',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                  onPressed: () => _showAddUserDialog(ref.context, ref),
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Joined')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: users.map((user) => DataRow(
                  cells: [
                    DataCell(Text(user['full_name'] ?? 'No name')),
                    DataCell(Text(user['user_id'] ?? 'No ID')),
                    DataCell(_buildRoleChip(user['role'] ?? 'user')),
                    DataCell(Text(user['phone'] ?? 'No phone')),
                    DataCell(Text(_formatDate(user['created_at']))),
                    DataCell(
                      PopupMenuButton<String>(
                        onSelected: (action) => _handleUserAction(action, user, ref),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'change_role', child: Text('Change Role')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role.toLowerCase()) {
      case 'admin':
        color = Colors.red;
        break;
      case 'user':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(role.toUpperCase()),
      backgroundColor: color.withValues(alpha: 26),
      labelStyle: TextStyle(color: color, fontSize: 12),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add User'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('User creation should be handled through registration/login.'),
            SizedBox(height: 16),
            Text('This feature would integrate with your auth system.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user, WidgetRef ref) {
    switch (action) {
      case 'edit':
        // Implement edit user functionality
        break;
      case 'change_role':
        _showChangeRoleDialog(ref.context, user, ref);
        break;
      case 'delete':
        // Implement delete user functionality (with confirmation)
        break;
    }
  }

  void _showChangeRoleDialog(BuildContext context, Map<String, dynamic> user, WidgetRef ref) {
    String selectedRole = user['role'] ?? 'user';
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change User Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change role for ${user['full_name'] ?? 'user'}'),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedRole,
              items: ['user', 'admin']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedRole = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(supabaseRepoProvider)
                  .adminUpdateUserRole(user['user_id'], selectedRole);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              ref.invalidate(adminUsersProvider);
            },
            child: const Text('Update Role'),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return 'Unknown';
    try {
      final date = DateTime.parse(createdAt.toString());
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
