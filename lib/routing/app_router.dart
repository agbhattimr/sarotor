import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/features/auth/login_screen.dart';
import 'package:sartor_order_management/features/dashboard/user_dashboard.dart';
import 'package:sartor_order_management/features/measurements/measurement_form_screen_new.dart';
import 'package:sartor_order_management/features/profile/profile_screen.dart';
import 'package:sartor_order_management/state/session/user_state.dart';

class AppRouter {
  final UserState sessionState;

  AppRouter(this.sessionState);

  late final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const UserDashboard(),
      ),
      GoRoute(
        path: '/measurements',
        builder: (context, state) => const MeasurementFormScreenNew(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = sessionState.when(
        initial: () => false,
        loading: () => false,
        authenticated: (profile) => true,
        unauthenticated: () => false,
        error: (message) => false,
      );

      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
}
