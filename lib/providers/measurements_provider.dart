import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_history.dart';
import 'package:sartor_order_management/services/measurement_repository.dart';
import 'package:sartor_order_management/state/session/session_provider.dart';

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

final measurementProvider =
    FutureProvider.autoDispose.family<Measurement?, String>((ref, id) async {
  final measurementRepository = ref.watch(measurementRepositoryProvider);
  return measurementRepository.getMeasurement(id);
});

final measurementHistoryProvider = FutureProvider.autoDispose
    .family<List<MeasurementHistory>, String>((ref, id) async {
  final measurementRepository = ref.watch(measurementRepositoryProvider);
  return measurementRepository.getHistory(id);
});
