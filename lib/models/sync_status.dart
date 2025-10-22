class SyncStatus {
  final bool isSyncing;
  final DateTime? lastSyncAttempt;
  final DateTime? lastSyncComplete;
  final bool? lastSyncSuccess;
  final String? lastSyncError;
  final int pendingChanges;

  const SyncStatus({
    this.isSyncing = false,
    this.lastSyncAttempt,
    this.lastSyncComplete,
    this.lastSyncSuccess,
    this.lastSyncError,
    this.pendingChanges = 0,
  });

  SyncStatus copyWith({
    bool? isSyncing,
    DateTime? lastSyncAttempt,
    DateTime? lastSyncComplete,
    bool? lastSyncSuccess,
    String? lastSyncError,
    int? pendingChanges,
  }) {
    return SyncStatus(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      lastSyncComplete: lastSyncComplete ?? this.lastSyncComplete,
      lastSyncSuccess: lastSyncSuccess ?? this.lastSyncSuccess,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      pendingChanges: pendingChanges ?? this.pendingChanges,
    );
  }
}