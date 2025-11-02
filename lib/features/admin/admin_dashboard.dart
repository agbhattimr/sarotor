import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final adminOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(supabaseRepoProvider).adminFetchOrders();
});

final adminUsersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(supabaseRepoProvider).adminFetchUsers();
});

final adminServiceManagementStatsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.watch(supabaseRepoProvider).getServiceManagementStats();
});

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStats = ref.watch(adminServiceManagementStatsProvider);
    final asyncOrders = ref.watch(adminOrdersProvider);
    final asyncUsers = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/admin/settings'),
          ),
        ],
      ),
      drawer: _buildAdminDrawer(context),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(adminOrdersProvider);
          ref.invalidate(adminUsersProvider);
          ref.invalidate(adminServiceManagementStatsProvider);
        },
        child: ResponsiveLayout(
          mobileBody: _buildMobileLayout(asyncStats, asyncOrders, asyncUsers, context, ref),
          tabletBody: _buildTabletLayout(asyncStats, asyncOrders, asyncUsers, context, ref),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'admin_dashboard_fab',
        onPressed: () => context.go('/admin/services/add'),
        tooltip: 'Add Service',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/dashboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Service Management'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/services');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Order Management'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/orders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Analytics'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/analytics');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Back to App'),
            onTap: () {
              Navigator.pop(context);
              context.go('/client');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    AsyncValue<Map<String, dynamic>> asyncStats,
    AsyncValue<List<Map<String, dynamic>>> asyncOrders,
    AsyncValue<List<Map<String, dynamic>>> asyncUsers,
    BuildContext context,
    WidgetRef ref,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(adminOrdersProvider);
        ref.invalidate(adminUsersProvider);
        ref.invalidate(adminServiceManagementStatsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Stats Cards
              asyncStats.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error loading stats: $e'),
                data: (stats) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Total Orders',
                            stats['total_orders'].toString(),
                            Icons.receipt_long,
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildMetricCard(
                            'Revenue',
                            'PKR${(stats['total_revenue_cents'] / 100.0).toStringAsFixed(0)}',
                            Icons.attach_money,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Active Services',
                            stats['active_services'].toString(),
                            Icons.build,
                            Colors.orange,
                          ),
                        ),
                                        Expanded(
                          child: _buildMetricCard(
                            'Users',
                            asyncUsers.maybeWhen(
                              data: (users) => users.length.toString(),
                              orElse: () => '0',
                            ),
                            Icons.people,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildQuickActionCard('Add Service', Icons.add, () => context.go('/admin/services')),
                  _buildQuickActionCard('View Orders', Icons.receipt_long, () => context.go('/admin/orders')),
                  _buildQuickActionCard('View Users', Icons.people, () => context.go('/admin/users')),
                  _buildQuickActionCard('Analytics', Icons.analytics, () => context.go('/admin/analytics')),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Orders
              const Text('Recent Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              asyncOrders.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (orders) => Column(
                  children: orders.take(5).map((order) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('Order ${order['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${order['status']}'),
                          Text('Total: PKR${((order['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: _buildStatusMenu(ref, order['id'] as String),
                      onTap: () => context.push('/admin/orders/${order['id']}'),
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(
    AsyncValue<Map<String, dynamic>> asyncStats,
    AsyncValue<List<Map<String, dynamic>>> asyncOrders,
    AsyncValue<List<Map<String, dynamic>>> asyncUsers,
    BuildContext context,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Metrics Row
          asyncStats.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (stats) => Row(
              children: [
                Expanded(child: _buildMetricCardLarge('Total Orders', stats['total_orders'].toString(), Icons.receipt_long, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildMetricCardLarge('Revenue', 'PKR${(stats['total_revenue_cents'] / 100.0).toStringAsFixed(2)}', Icons.attach_money, Colors.green)),
                const SizedBox(width: 16),
                Expanded(child: _buildMetricCardLarge('Active Services', stats['active_services'].toString(), Icons.build, Colors.orange)),
                const SizedBox(width: 16),
                Expanded(child: _buildMetricCardLarge('Users', asyncUsers.maybeWhen(data: (users) => users.length.toString(), orElse: () => '0'), Icons.people, Colors.purple)),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildQuickActionCard('Service Management', Icons.build, () => context.go('/admin/services')),
              _buildQuickActionCard('Order Management', Icons.receipt_long, () => context.go('/admin/orders')),
              _buildQuickActionCard('User Management', Icons.people, () => context.go('/admin/users')),
              _buildQuickActionCard('Analytics', Icons.analytics, () => context.go('/admin/analytics')),
            ],
          ),

          const SizedBox(height: 32),

          // Recent Orders Table
          Row(
            children: [
              const Text('Recent Orders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text('View All Orders'),
                onPressed: () => context.go('/admin/orders'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          asyncOrders.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            data: (orders) => Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: orders.take(5).map((order) => DataRow(
                  cells: [
                    DataCell(Text(order['id'].toString().substring(0, 8))),
                    DataCell(Text(order['status'])),
                    DataCell(Text('PKR${((order['total_cents'] ?? 0) / 100.0).toStringAsFixed(2)}')),
                    DataCell(_buildStatusMenu(ref, order['id'] as String)),
                  ],
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildStatusMenu(WidgetRef ref, String orderId) {
    return PopupMenuButton<String>(
      onSelected: (s) => ref.read(supabaseRepoProvider)
          .adminUpdateOrderStatus(orderId, s)
          .then((_) => ref.refresh(adminOrdersProvider)),
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem(value: 'pending', child: Text('pending')),
        const PopupMenuItem(value: 'in_progress', child: Text('in_progress')),
        const PopupMenuItem(value: 'ready', child: Text('ready')),
        const PopupMenuItem(value: 'completed', child: Text('completed')),
        const PopupMenuItem(value: 'cancelled', child: Text('cancelled')),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCardLarge(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
