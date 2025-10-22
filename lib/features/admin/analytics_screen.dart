import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final analyticsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return Supabase.instance.client.rpc('analytics_overview_guarded').then((resp) {
    if (resp is List && resp.isNotEmpty) {
      return resp.first as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  });
});

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(analyticsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (m) {
          if (m.isEmpty) return const Center(child: Text('No data'));
          return ResponsiveLayout(
            mobileBody: _buildMobileLayout(m),
            tabletBody: _buildTabletLayout(m),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(Map<String, dynamic> m) {
    final revenue = ((m['revenue_cents'] ?? 0) / 100.0).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard('Total Orders', '${m['total_orders']}', Icons.shopping_cart, Colors.blue),
          _buildStatCard('Revenue', '\$$revenue', Icons.attach_money, Colors.green),
          const SizedBox(height: 12),
          _buildStatCard('Pending', '${m['pending']}', Icons.pending, Colors.orange),
          _buildStatCard('In Progress', '${m['in_progress']}', Icons.construction, Colors.cyan),
          _buildStatCard('Ready', '${m['ready']}', Icons.check_circle, Colors.lightGreen),
          _buildStatCard('Completed', '${m['completed']}', Icons.done, Colors.green),
          _buildStatCard('Cancelled', '${m['cancelled']}', Icons.cancel, Colors.red),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(Map<String, dynamic> m) {
    final revenue = ((m['revenue_cents'] ?? 0) / 100.0).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
        children: [
          _buildStatCard('Total Orders', '${m['total_orders']}', Icons.shopping_cart, Colors.blue),
          _buildStatCard('Revenue', '\$$revenue', Icons.attach_money, Colors.green),
          _buildStatCard('Pending', '${m['pending']}', Icons.pending, Colors.orange),
          _buildStatCard('In Progress', '${m['in_progress']}', Icons.construction, Colors.cyan),
          _buildStatCard('Ready', '${m['ready']}', Icons.check_circle, Colors.lightGreen),
          _buildStatCard('Completed', '${m['completed']}', Icons.done, Colors.green),
          _buildStatCard('Cancelled', '${m['cancelled']}', Icons.cancel, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
