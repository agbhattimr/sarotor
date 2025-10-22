import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/models/models.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/state/session/user_state.dart';
import 'package:sartor_order_management/shared/components/order_card.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final userStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final client = Supabase.instance.client;
  final uid = client.auth.currentUser!.id;
  
  // Fetch user stats
  final orders = await client.from('orders').select('id,status,total_cents,created_at').eq('user_id', uid);
  final measurements = await client.from('measurements').select('id').eq('user_id', uid);
  
  final ordersList = orders as List;
  final totalOrders = ordersList.length;
  final activeOrders = ordersList.where((o) => !['completed', 'cancelled'].contains(o['status'])).length;
  final totalSpent = ordersList.fold<int>(0, (sum, o) => sum + (o['total_cents'] as int));
  
  return {
    'activeOrders': activeOrders,
    'totalOrders': totalOrders,
    'totalSpent': totalSpent,
    'measurementCount': (measurements as List).length,
  };
});

final recentOrdersProvider = FutureProvider<List<OrderSummary>>((ref) async {
  final client = Supabase.instance.client;
  final uid = client.auth.currentUser!.id;
  final resp = await client.from('orders')
    .select('id,status,total_cents,created_at')
    .eq('user_id', uid)
    .order('created_at', ascending: false)
    .limit(3);
  
  return (resp as List).map((e) => OrderSummary.fromMap(e as Map<String, dynamic>)).toList();
});

final recentMeasurementsProvider = FutureProvider<List<Measurement>>((ref) async {
  final client = Supabase.instance.client;
  final uid = client.auth.currentUser!.id;
  final resp = await client.from('measurements')
    .select()
    .eq('user_id', uid)
    .order('created_at', ascending: false)
    .limit(3);
  
  return (resp as List).map((e) => Measurement.fromSupabase(e as Map<String, dynamic>)).toList();
});

class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final sessionState = ref.watch(sessionProvider);
    final statsAsync = ref.watch(userStatsProvider);
    final recentOrdersAsync = ref.watch(recentOrdersProvider);
    final recentMeasurementsAsync = ref.watch(recentMeasurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => ref.read(sessionProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          )
        ],
      ),
      body: ResponsiveLayout(
        mobileBody: _buildMobileLayout(context, user, sessionState, statsAsync, recentOrdersAsync, recentMeasurementsAsync),
        tabletBody: _buildTabletLayout(context, user, sessionState, statsAsync, recentOrdersAsync, recentMeasurementsAsync),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, User? user, UserState sessionState, AsyncValue<Map<String, dynamic>> statsAsync, AsyncValue<List<OrderSummary>> recentOrdersAsync, AsyncValue<List<Measurement>> recentMeasurementsAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          _buildWelcomeHeader(context, user, sessionState),
          const SizedBox(height: 24),

          // Quick Stats
          _buildStatsGrid(context, statsAsync),
          const SizedBox(height: 24),

          // Quick Actions
          _buildQuickActions(context),
          const SizedBox(height: 24),

          // Recent Orders
          _buildRecentOrders(context, recentOrdersAsync),
          const SizedBox(height: 24),

          // Recent Measurements
          _buildRecentMeasurements(context, recentMeasurementsAsync),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, User? user, UserState sessionState, AsyncValue<Map<String, dynamic>> statsAsync, AsyncValue<List<OrderSummary>> recentOrdersAsync, AsyncValue<List<Measurement>> recentMeasurementsAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(context, user, sessionState),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(context, statsAsync),
                    const SizedBox(height: 24),
                    _buildQuickActions(context),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildRecentOrders(context, recentOrdersAsync),
                    const SizedBox(height: 24),
                    _buildRecentMeasurements(context, recentMeasurementsAsync),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, User? user, UserState sessionState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                sessionState.when(
                  initial: () => 'U',
                  loading: () => 'U',
                  authenticated: (profile) =>
                      (profile.fullName?.isNotEmpty == true)
                          ? profile.fullName![0].toUpperCase()
                          : user?.email?[0].toUpperCase() ?? 'U',
                  unauthenticated: () => 'U',
                  error: (message) => 'U',
                ),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sessionState.when(
                      initial: () => user?.email ?? 'User',
                      loading: () => user?.email ?? 'User',
                      authenticated: (profile) =>
                          profile.fullName ?? user?.email ?? 'User',
                      unauthenticated: () => 'User',
                      error: (message) => user?.email ?? 'User',
                    ),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, AsyncValue<Map<String, dynamic>> statsAsync) {
    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error loading stats: $e')),
      data: (stats) => LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isWide ? 1.5 : 1.2,
            children: [
              _buildStatCard(
                context,
                'Active Orders',
                '${stats['activeOrders']}',
                Icons.shopping_cart,
                Colors.blue,
              ),
              _buildStatCard(
                context,
                'Total Orders',
                '${stats['totalOrders']}',
                Icons.receipt_long,
                Colors.green,
              ),
              _buildStatCard(
                context,
                'Total Spent',
                '\$${(stats['totalSpent'] / 100).toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.orange,
              ),
              _buildStatCard(
                context,
                'Measurements',
                '${stats['measurementCount']}',
                Icons.straighten,
                Colors.purple,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildActionButton(
                    context,
                    'New Order',
                    Icons.add_shopping_cart,
                    () => context.go('/orders/new'),
                  ),
                  _buildActionButton(
                    context,
                    'Add Measurements',
                    Icons.straighten,
                    () => context.go('/measurements'),
                  ),
                  _buildActionButton(
                    context,
                    'Browse Services',
                    Icons.store,
                    () => context.go('/catalog'),
                  ),
                  _buildActionButton(
                    context,
                    'View Orders',
                    Icons.receipt_long,
                    () => context.go('/orders'),
                  ),
                  _buildActionButton(
                    context,
                    'Edit Profile',
                    Icons.person,
                    () => context.go('/profile'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, AsyncValue<List<OrderSummary>> recentOrdersAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/orders'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            recentOrdersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error loading orders: $e')),
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No orders yet. Create your first order!'),
                    ),
                  );
                }
                return Column(
                  children: orders.map((order) => _buildOrderCard(context, order)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderSummary order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(order.status),
          child: Icon(
            _getStatusIcon(order.status),
            color: Colors.white,
          ),
        ),
        title: Text('Order ${order.id.substring(0, 8)}'),
        subtitle: Text('${_formatDate(order.createdAt)} • \$${(order.totalCents / 100).toStringAsFixed(2)}'),
        trailing: Chip(
          label: Text(
            order.status.toUpperCase(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(
            (_getStatusColor(order.status).r * 255.0).round() & 0xff,
            (_getStatusColor(order.status).g * 255.0).round() & 0xff,
            (_getStatusColor(order.status).b * 255.0).round() & 0xff,
            0.2,
          ),
          labelStyle: TextStyle(color: _getStatusColor(order.status)),
        ),
      ),
    );
  }

  Widget _buildRecentMeasurements(BuildContext context, AsyncValue<List<Measurement>> recentMeasurementsAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Measurement Profiles',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/measurements'),
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            recentMeasurementsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error loading measurements: $e')),
              data: (measurements) {
                if (measurements.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No measurements yet. Add your first measurement profile!'),
                    ),
                  );
                }
                return Column(
                  children: measurements.map((measurement) => OrderCard(
                    measurement: measurement,
                    isSelected: false,
                    onTap: () => context.go('/measurements'),
                    appContext: AppContext.client,
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'in_progress':
        return Icons.work;
      case 'ready':
        return Icons.check_circle;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatMeasurements(Measurement measurement) {
    final parts = <String>[];
    
    // Show key measurements in order of importance
    if (measurement.chest != null) parts.add('Chest: ${measurement.chest}"');
    if (measurement.waist != null) parts.add('Waist: ${measurement.waist}"');
    if (measurement.shoulder != null) parts.add('Shoulder: ${measurement.shoulder}"');
    if (measurement.shirtLength != null) parts.add('Shirt: ${measurement.shirtLength}"');
    if (measurement.shalwarLength != null) parts.add('Shalwar: ${measurement.shalwarLength}"');
    if (measurement.trouserLength != null) parts.add('Trouser: ${measurement.trouserLength}"');
    
    if (parts.isEmpty) return 'No measurements';
    return parts.take(3).join(' • ');
  }
}
