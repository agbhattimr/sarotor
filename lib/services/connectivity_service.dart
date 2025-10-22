import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider((ref) => Connectivity());

final connectivityStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged.map((results) => results.first);
});
