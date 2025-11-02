import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'package:sartor_order_management/models/measurement_template.dart';
import 'package:sartor_order_management/models/measurement_history.dart';

class MeasurementException implements Exception {
  final String message;
  MeasurementException(this.message);
  
  @override
  String toString() => message;
}

// Providers
final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  return MeasurementRepository(Supabase.instance.client);
});

final measurementSyncProvider = StateNotifierProvider<MeasurementSyncNotifier, SyncStatus>((ref) {
  return MeasurementSyncNotifier();
});

class MeasurementRepository {
  final SupabaseClient _client;

  MeasurementRepository(this._client);

  /// Creates a new measurement
  Future<Measurement> createMeasurement(Measurement measurement) async {
    try {
      final response = await _client
          .from('measurements')
          .insert(measurement.toJson())
          .select()
          .single();
      
      return Measurement.fromJson(response);
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to create measurement: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error creating measurement: $e');
    }
  }

  /// Updates an existing measurement
  Future<Measurement> updateMeasurement(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .from('measurements')
          .update(updates)
          .eq('id', id)
          .select()
          .single();
      
      return Measurement.fromJson(response);
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to update measurement: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error updating measurement: $e');
    }
  }

  /// Deletes a measurement by ID
  Future<void> deleteMeasurement(String id) async {
    try {
      await _client.from('measurements').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to delete measurement: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error deleting measurement: $e');
    }
  }

  /// Gets all measurements for a user
  Future<List<Measurement>> getMeasurements(String userId) async {
    try {
      final response = await _client
          .from('measurements')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return response
          .map((e) => Measurement.fromJson(e))
          .toList();
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to get measurements: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error getting measurements: $e');
    }
  }

  /// Sets a measurement as active and deactivates others
  Future<Measurement> setActiveMeasurement(String id) async {
    try {
      // First deactivate all measurements
      await _client
          .from('measurements')
          .update({'is_active': false})
          .neq('id', id);
      
      // Then activate the selected one
      final response = await _client
          .from('measurements')
          .update({'is_active': true})
          .eq('id', id)
          .select()
          .single();
      
      return Measurement.fromJson(response);
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to set active measurement: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error setting active measurement: $e');
    }
  }

  /// Gets the currently active measurement for a user
  Future<Measurement?> getActiveMeasurement(String userId) async {
    try {
      final response = await _client
          .from('measurements')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .maybeSingle();
      
      if (response == null) return null;
      return Measurement.fromJson(response);
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to get active measurement: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error getting active measurement: $e');
    }
  }
  
  /// Gets a single measurement by ID
  Future<Measurement?> getMeasurement(String id) async {
    try {
      final response = await _client
          .from('measurements')
          .select()
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) return null;
      return Measurement.fromJson(response);
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to get measurement: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error getting measurement: $e');
    }
  }

  /// Gets all available measurement templates
  Future<List<MeasurementTemplate>> getTemplates() async {
    try {
      final response = await _client
          .from('measurement_templates')
          .select();
      
      return response.map((item) => MeasurementTemplate.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to get templates: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error getting templates: $e');
    }
  }

  /// Gets the history for a measurement
  Future<List<MeasurementHistory>> getHistory(String measurementId) async {
    try {
      final response = await _client
          .from('measurement_history')
          .select()
          .eq('measurement_id', measurementId)
          .order('timestamp', ascending: false);
      
      return response
          .map((e) => MeasurementHistory.fromJson(e))
          .toList();
    } on PostgrestException catch (e) {
      throw MeasurementException('Failed to get measurement history: ${e.message}');
    } catch (e) {
      throw MeasurementException('Unexpected error getting measurement history: $e');
    }
  }
}

class MeasurementSyncNotifier extends StateNotifier<SyncStatus> {
  MeasurementSyncNotifier() : super(const SyncStatus.initial());

  void startSync() {
    state = const SyncStatus.syncing();
  }

  void completeSync() {
    state = SyncStatus.completed(DateTime.now());
  }

  void setError(String message) {
    state = SyncStatus.error(message);
  }

  void reset() {
    state = const SyncStatus.initial();
  }
}

class SyncStatus {
  final bool isSyncing;
  final String? error;
  final DateTime? lastSync;

  const SyncStatus.initial() 
    : isSyncing = false, 
      error = null, 
      lastSync = null;

  const SyncStatus.syncing() 
    : isSyncing = true, 
      error = null, 
      lastSync = null;

  const SyncStatus.completed(DateTime timestamp) 
    : isSyncing = false, 
      error = null, 
      lastSync = timestamp;

  const SyncStatus.error(String errorMessage) 
    : isSyncing = false, 
      error = errorMessage, 
      lastSync = null;
}
