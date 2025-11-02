import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/features/admin/admin_dashboard.dart';
import 'package:sartor_order_management/features/admin/analytics_screen.dart';
import 'package:sartor_order_management/features/admin/measurement_templates_screen.dart';
import 'package:sartor_order_management/features/admin/add_service_screen.dart';
import 'package:sartor_order_management/features/admin/edit_service_screen.dart';
import 'package:sartor_order_management/features/admin/user_management_screen.dart';
import 'package:sartor_order_management/features/admin/service_management_screen.dart';
import 'package:sartor_order_management/features/admin/order_management_screen.dart';
import 'package:sartor_order_management/features/admin/admin_settings_screen.dart';
import 'package:sartor_order_management/features/auth/login_screen.dart';
import 'package:sartor_order_management/features/auth/register_screen.dart';
import 'package:sartor_order_management/features/profile/profile_screen.dart';
import 'package:sartor_order_management/routing/client_routes.dart';
import 'package:sartor_order_management/routing/navigator_keys.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/state/session/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final sessionState = ref.watch(sessionProvider);
  return AppRouter(sessionState).router;
});

class AppRouter {
  final UserState sessionState;

  AppRouter(this.sessionState);

  late final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/client/catalog',
    routes: [
      clientRoutes,
      // Admin routes with role protection
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) =>
            const _AdminAuthGuard(child: AdminDashboard()),
      ),
      GoRoute(
        path: '/admin/services',
        builder: (context, state) =>
            const _AdminAuthGuard(child: ServiceManagementScreen()),
      ),
      GoRoute(
        path: '/admin/services/add',
        builder: (context, state) =>
            const _AdminAuthGuard(child: AddServiceScreen()),
      ),
      GoRoute(
        path: '/admin/services/:id/edit',
        builder: (context, state) {
          final serviceId = int.tryParse(state.pathParameters['id'] ?? '');
          if (serviceId == null) {
            return const Scaffold(
              body: Center(
                child: Text('Invalid service ID'),
              ),
            );
          }
          return _AdminAuthGuard(child: EditServiceScreen(serviceId: serviceId));
        },
      ),
      GoRoute(
        path: '/admin/orders',
        builder: (context, state) =>
            const _AdminAuthGuard(child: OrderManagementScreen()),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) =>
            const _AdminAuthGuard(child: UserManagementScreen()),
      ),
      GoRoute(
        path: '/admin/analytics',
        builder: (context, state) =>
            const _AdminAuthGuard(child: AnalyticsScreen()),
      ),
      GoRoute(
        path: '/admin/measurement-templates',
        builder: (context, state) =>
            const _AdminAuthGuard(child: MeasurementTemplatesScreen()),
      ),
      GoRoute(
        path: '/admin/settings',
        builder: (context, state) =>
            const _AdminAuthGuard(child: AdminSettingsScreen()),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    ],
    redirect: (context, state) {
      final isLoggedIn = sessionState.when(
        initial: () => false,
        loading: () => false,
        authenticated: (profile) => true,
        unauthenticated: () => false,
        error: (message) => false,
      );

      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/client/catalog';
      }

      return null;
    },
  );
}

// Admin authentication guard
class _AdminAuthGuard extends ConsumerWidget {
  final Widget child;

  const _AdminAuthGuard({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider);

    return sessionState.maybeWhen(
      authenticated: (profile) {
        if (profile.role == 'admin') {
          return child;
        } else {
          // Not an admin - redirect to main app
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/client');
          });
          return const Scaffold(
            body: Center(
              child: Text('Access Denied: Admin privileges required'),
            ),
          );
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      unauthenticated: () => const LoginScreen(),
      error: (message) =>
          Scaffold(body: Center(child: Text('Error: $message'))),
      orElse: () => const LoginScreen(),
    );
  }
}
