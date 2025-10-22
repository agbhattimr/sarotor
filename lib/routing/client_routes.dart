import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sartor_order_management/features/catalog/catalog_screen.dart';
import 'package:sartor_order_management/features/dashboard/user_dashboard.dart';
import 'package:sartor_order_management/features/orders/new_order_customer_details_screen.dart';
import 'package:sartor_order_management/features/orders/measurements_selection_screen.dart';
import 'package:sartor_order_management/features/orders/new_order_review_screen.dart';
import 'package:sartor_order_management/features/orders/new_order_screen.dart';
import 'package:sartor_order_management/features/orders/orders_list_screen.dart';
import 'package:sartor_order_management/features/orders/order_tracking_screen.dart';
import 'package:sartor_order_management/features/profile/measurements_list_screen.dart';
import 'package:sartor_order_management/services/analytics_service.dart';

// This is the main layout for the client-facing app.
// It includes the bottom navigation bar.
class MainLayout extends ConsumerWidget {
  final Widget child;
  const MainLayout({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).uri.toString();
    
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(currentPath),
        onTap: (index) => _onTap(context, index, ref),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'New Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Measurements',
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(String path) {
    if (path.startsWith('/client/orders/')) return 3;
    
    switch (path) {
      case '/client':
        return 0;
      case '/client/catalog':
        return 1;
      case '/client/orders/new':
        return 2;
      case '/client/orders':
        return 3;
      case '/client/measurements':
        return 4;
      default:
        return 0;
    }
  }

  void _onTap(BuildContext context, int index, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);
    String destination = '';
    switch (index) {
      case 0:
        destination = 'Home';
        context.go('/client');
        break;
      case 1:
        destination = 'Catalog';
        context.go('/client/catalog');
        break;
      case 2:
        destination = 'New Order';
        context.go('/client/orders/new');
        break;
      case 3:
        destination = 'Orders';
        context.go('/client/orders');
        break;
      case 4:
        destination = 'Measurements';
        context.go('/client/measurements');
        break;
    }
    analytics.trackUserEngagement('BottomNav', parameters: {'destination': destination});
  }
}

// Using a ShellRoute to wrap all client-facing pages with the MainLayout
final clientRoutes = ShellRoute(
  builder: (context, state, child) {
    return MainLayout(child: child);
  },
  routes: [
    GoRoute(
      path: '/client',
      builder: (context, state) => const UserDashboard(),
      routes: [
        GoRoute(
          path: 'catalog',
          builder: (context, state) => const CatalogScreen(),
        ),
        GoRoute(
          path: 'orders',
          builder: (context, state) => const OrdersListScreen(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const NewOrderScreen(),
              routes: [
                GoRoute(
                  path: 'measurements',
                  builder: (context, state) => const MeasurementsSelectionScreen(),
                ),
                GoRoute(
                  path: 'customer-details',
                  builder: (context, state) => const NewOrderCustomerDetailsScreen(),
                ),
                GoRoute(
                  path: 'review',
                  builder: (context, state) => const NewOrderReviewScreen(),
                ),
              ],
            ),
            GoRoute(
              path: ':id',
              builder: (context, state) => const OrderTrackingScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'measurements',
          builder: (context, state) => const MeasurementsListScreen(),
        ),
      ],
    ),
  ],
);
