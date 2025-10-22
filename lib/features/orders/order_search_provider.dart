import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_search_provider.freezed.dart';

@freezed
class OrderSearchState with _$OrderSearchState {
  const factory OrderSearchState({
    @Default('') String query,
    @Default([]) List<String> statuses,
    DateTime? startDate,
    DateTime? endDate,
    String? serviceType,
  }) = _OrderSearchState;
}

class OrderSearchNotifier extends StateNotifier<OrderSearchState> {
  OrderSearchNotifier() : super(const OrderSearchState());

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void toggleStatus(String status) {
    final statuses = state.statuses.toList();
    if (statuses.contains(status)) {
      statuses.remove(status);
    } else {
      statuses.add(status);
    }
    state = state.copyWith(statuses: statuses);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setServiceType(String? serviceType) {
    state = state.copyWith(serviceType: serviceType);
  }
}

final orderSearchProvider = StateNotifierProvider<OrderSearchNotifier, OrderSearchState>((ref) {
  return OrderSearchNotifier();
});
