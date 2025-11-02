import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';

enum AppType {
  customer,
  rider,
  tailor,
  admin,
}

class ApiService {
  final AppType appType;
  final String? userRole;

  ApiService({required this.appType, this.userRole});

  String get _apiBaseUrl {
    // In a real app, this would come from a config file
    return 'https://your-supabase-url.com/rest/v1';
  }

  String get _roleBasedPath {
    switch (userRole) {
      case 'client':
        return 'client';
      case 'rider':
        return 'rider';
      case 'tailor':
        return 'tailor';
      case 'manager':
      case 'admin':
        return 'admin';
      default:
        return 'client'; // Default to client for safety
    }
  }

  String getEndpoint(String path) {
    return '$_apiBaseUrl/$_roleBasedPath/$path';
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final session = ref.watch(sessionProvider);
  final userRole = session.whenOrNull(
    authenticated: (profile) => profile.role,
  );

  // This could be determined by the app flavor or some other config
  const appType = AppType.customer;

  return ApiService(appType: appType, userRole: userRole);
});
