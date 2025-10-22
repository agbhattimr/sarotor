import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';
import 'package:sartor_order_management/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  return MeasurementRepository(Supabase.instance.client);
});

final measurementsProvider = FutureProvider<List<Measurement>>((ref) async {
  final measurementRepository = ref.watch(measurementRepositoryProvider);
  final session = ref.watch(sessionProvider);

  final userId = session.when(
    initial: () => null,
    loading: () => null,
    authenticated: (profile) => profile.userId,
    unauthenticated: () => null,
    error: (message) => null,
  );

  if (userId != null) {
    return measurementRepository.getMeasurements(userId);
  } else {
    return [];
  }
});
