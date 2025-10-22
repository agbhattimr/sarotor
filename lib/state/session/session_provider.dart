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
      final data = await _client
          .from('profiles')
          .select('user_id, full_name, phone, role')
          .eq('user_id', userId)
          .single();
      
      final profile = UserProfile.fromMap(data);
      state = UserState.authenticated(profile: profile);
    } catch (e) {
      state = UserState.error(e.toString());
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
