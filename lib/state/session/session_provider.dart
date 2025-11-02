import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_state.dart';

final sessionProvider = StateNotifierProvider<SessionNotifier, UserState>((ref) {
  return SessionNotifier();
});

class SessionNotifier extends StateNotifier<UserState> {
  final SupabaseClient _client = Supabase.instance.client;
  StreamSubscription<AuthState>? _authStateSubscription;

  SessionNotifier() : super(const UserState.initial()) {
    _authStateSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _fetchProfile(session.user.id);
      } else {
        state = const UserState.unauthenticated();
      }
    });
  }

  Future<void> _fetchProfile(String userId) async {
    state = const UserState.loading();
    try {
      // Try to get existing profile
      final existingProfile = await _client
          .from('profiles')
          .select('user_id, full_name, phone, role')
          .eq('user_id', userId)
          .maybeSingle();

      UserProfile profile;
      if (existingProfile != null) {
        profile = UserProfile.fromMap(existingProfile);
      } else {
        // If no profile exists, create a default one
        await _client.from('profiles').insert({
          'user_id': userId,
          'full_name': 'User',
          'phone': null,
          'role': 'customer',
        });

        profile = UserProfile(
          userId: userId,
          fullName: 'User',
          phone: null,
          role: 'customer',
        );
      }

      state = UserState.authenticated(profile: profile);
    } catch (e) {
      // Even if profile operations fail, at least authenticate the user
      final fallbackProfile = UserProfile(
        userId: userId,
        fullName: null,
        phone: null,
        role: 'customer',
      );
      state = UserState.authenticated(profile: fallbackProfile);
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const UserState.unauthenticated();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
