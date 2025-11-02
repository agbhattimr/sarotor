import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:sartor_order_management/l10n/app_localizations.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/services/connectivity_service.dart';
import 'package:sartor_order_management/services/order_repository.dart';
import 'package:sartor_order_management/services/supabase_repo.dart';
import 'package:sartor_order_management/models/order_model.dart';
import 'package:sartor_order_management/features/measurements/widgets/shimmer_loading.dart';
import 'order_search_provider.dart';

class PaginatedOrdersState {
  final List<Order> orders;
  final bool isLoading;
  final bool hasMore;
  final int page;

  PaginatedOrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
  });

  PaginatedOrdersState copyWith({
    List<Order>? orders,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return PaginatedOrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

class PaginatedOrdersNotifier extends StateNotifier<PaginatedOrdersState> {
  final OrderRepository _repository;
  final String _userId;
  final Ref _ref;

  PaginatedOrdersNotifier(this._repository, this._userId, this._ref)
      : super(PaginatedOrdersState()) {
    fetchFirstPage();
  }

  Future<void> fetchFirstPage() async {
    state = PaginatedOrdersState(isLoading: true);
    await fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    final searchState = _ref.read(orderSearchProvider);
    final newOrders = await _repository.getUserOrders(
      _userId,
      query: searchState.query,
      statuses: searchState.statuses,
      startDate: searchState.startDate,
      endDate: searchState.endDate,
      serviceType: searchState.serviceType,
      page: state.page,
    );

    state = state.copyWith(
      orders: [...state.orders, ...newOrders],
      isLoading: false,
      hasMore: newOrders.isNotEmpty,
      page: state.page + 1,
    );
  }

  void refresh() {
    state = PaginatedOrdersState();
    fetchFirstPage();
  }
}

final paginatedOrdersProvider =
    StateNotifierProvider.autoDispose<PaginatedOrdersNotifier, PaginatedOrdersState>((ref) {
  final repository = ref.read(orderRepositoryProvider);
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) throw Exception('User not authenticated');

  final notifier = PaginatedOrdersNotifier(repository, userId, ref);

  ref.listen(orderSearchProvider, (_, __) => notifier.refresh());
  // ref.debounce(const Duration(milliseconds: 500), () {
  //   notifier.refresh();
  // });

  // Refresh data when coming back online
  ref.listen<AsyncValue<ConnectivityResult>>(connectivityStatusProvider, (_, next) {
    if (next.value == ConnectivityResult.mobile || next.value == ConnectivityResult.wifi) {
      notifier.refresh();
    }
  });

  return notifier;
});

class OrderTrackingScreen extends ConsumerStatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(paginatedOrdersProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginatedState = ref.watch(paginatedOrdersProvider);
    final orders = paginatedState.orders;
    final connectivityStatus = ref.watch(connectivityStatusProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: Text(orders.isNotEmpty ? '${l10n.myOrders} (${orders.length})' : l10n.myOrders),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.createTestOrder,
            onPressed: () => _createTestOrder(),
            padding: const EdgeInsets.all(16.0),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refreshOrders,
            onPressed: () {
              ref.read(paginatedOrdersProvider.notifier).refresh();
            },
            padding: const EdgeInsets.all(16.0),
          ),
        ],
      ),
      body: Column(
        children: [
          if (connectivityStatus.value == ConnectivityResult.none)
            const _OfflineIndicator(),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: _buildOrderList(paginatedState),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(PaginatedOrdersState state) {
    if (state.orders.isEmpty && state.isLoading) {
      return const _OrderListSkeleton();
    }

    if (state.orders.isEmpty && !state.isLoading) {
      return _buildEmptyState(ref.watch(connectivityStatusProvider).value == ConnectivityResult.none);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(paginatedOrdersProvider.notifier).refresh();
      },
      child: AnimationLimiter(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: state.orders.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.orders.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final order = state.orders[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _OrderCard(order: order),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isOffline) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOffline ? Icons.signal_wifi_off_rounded : Icons.search_off_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
            ),
            const SizedBox(height: 24),
            Text(
              isOffline ? l10n.youAreOffline : l10n.noOrdersFound,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              isOffline
                  ? l10n.showingCachedData
                  : l10n.tryAdjustingYourSearchOrFilters,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final searchNotifier = ref.read(orderSearchProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Semantics(
        label: l10n.searchByTrackingIdOrItem,
        child: TextField(
          onChanged: (value) {
            searchNotifier.setQuery(value);
          },
          decoration: InputDecoration(
            hintText: l10n.searchByTrackingIdOrItem,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final searchState = ref.watch(orderSearchProvider);
    final searchNotifier = ref.read(orderSearchProvider.notifier);
    final statuses = ['pending', 'confirmed', 'in_progress', 'ready_for_pickup', 'completed', 'cancelled'];
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          ...statuses.map((status) {
            return FilterChip(
              label: Text(status.replaceAll('_', ' ').toUpperCase()),
              selected: searchState.statuses.contains(status),
              onSelected: (selected) {
                searchNotifier.toggleStatus(status);
              },
              tooltip: l10n.filterByStatus(status.replaceAll('_', ' ')),
            );
          }),
          ActionChip(
            avatar: const Icon(Icons.calendar_today),
            label: const Text('Date'),
            tooltip: l10n.filterByDate,
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: searchState.startDate != null && searchState.endDate != null
                    ? DateTimeRange(start: searchState.startDate!, end: searchState.endDate!)
                    : null,
              );
              if (picked != null) {
                searchNotifier.setDateRange(picked.start, picked.end);
              }
            },
          ),
        ],
      ),
    );
  }

  void _createTestOrder() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final repository = ref.read(orderRepositoryProvider);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseLoginFirst)),
        );
        return;
      }

      // Create a test order
      final order = await repository.createOrder(
        userId: userId,
        measurementId: null,
        totalCents: 2500, // Rs. 2,500
        notes: 'Test order created for demonstration',
        items: [
          {
            'service_id': 1,
            'service_name': 'Simple Suit',
            'quantity': 1,
            'price': 2000,
            'notes': 'Test item 1',
          },
          {
            'service_id': 9, 
            'service_name': 'Dupatta Stitching',
            'quantity': 1,
            'price': 500,
            'notes': 'Test item 2',
          },
        ],
      );

      // Refresh the orders list
      ref.read(paginatedOrdersProvider.notifier).refresh();
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.testOrderCreated(order.trackingId)),
          duration: const Duration(seconds: 3),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorCreatingOrder(e.toString()))),
      );
    }
  }
}

class _OfflineIndicator extends StatelessWidget {
  const _OfflineIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.amber.shade700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            l10n.youAreCurrentlyOffline,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _OrderListSkeleton extends StatelessWidget {
  const _OrderListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      isLoading: true,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => const _OrderCardSkeleton(),
      ),
    );
  }
}

class _OrderCardSkeleton extends StatelessWidget {
  const _OrderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 24,
                  width: 180,
                  color: Colors.grey.shade300,
                ),
                Container(
                  height: 28,
                  width: 90,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 16,
              width: 100,
              color: Colors.grey.shade300,
            ),
            const Divider(height: 32),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 50,
                  color: Colors.grey.shade300,
                ),
                const Spacer(),
                Container(
                  height: 20,
                  width: 80,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isExpanded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Semantics(
            label:
                '${l10n.order} #${widget.order.trackingId}, dated ${widget.order.formattedDate}, for a total of ${widget.order.formattedTotal}. Status: ${widget.order.status.name.replaceAll('_', ' ')}.',
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${l10n.order} #${widget.order.trackingId}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.order.formattedDate,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          _OrderActions(
                            order: widget.order,
                            isExpanded: _isExpanded,
                            onToggleExpansion: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        context,
                        icon: Icons.receipt_long,
                        label: l10n.total,
                        value: 'PKR ${widget.order.totalCents.toStringAsFixed(0)}',
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _isExpanded ? _buildExpandedContent(context) : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _OrderStatusTimeline(
          status: widget.order.status,
          createdAt: widget.order.createdAt,
          updatedAt: widget.order.updatedAt,
        ),
        const SizedBox(height: 16),
        if (widget.order.items.isNotEmpty) ...[
          _buildItemsSection(context),
          const SizedBox(height: 16),
        ],
        if (widget.order.notes != null && widget.order.notes!.isNotEmpty) ...[
          _buildNotesSection(context),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.secondary),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsSection(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.items,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...widget.order.items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                '• ${item.serviceName} (x${item.quantity}) - PKR ${item.priceCents.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium,
              ),
            )),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.notes,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          widget.order.notes!,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _OrderStatusTimeline extends StatelessWidget {
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const _OrderStatusTimeline({
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const statuses = [
      OrderStatus.pending,
      OrderStatus.confirmed,
      OrderStatus.inProgress,
      OrderStatus.readyForPickup,
      OrderStatus.completed
    ];
    final int currentStatusIndex = statuses.indexOf(status);

    if (status == OrderStatus.cancelled) {
      return _buildStatusTile(
        context,
        icon: Icons.cancel,
        title: l10n.orderCancelled,
        subtitle: l10n.thisOrderHasBeenCancelled,
        isFirst: true,
        isLast: true,
        isActive: true,
        isCompleted: true,
        color: theme.colorScheme.error,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.orderProgress, style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        ...List.generate(statuses.length, (index) {
          final isCompleted = index <= currentStatusIndex;
          final isActive = index == currentStatusIndex;
          final statusName = statuses[index];

          String subtitle = l10n.pending;
          if (isCompleted) {
            if (statusName == OrderStatus.pending) {
              subtitle =
                  '${l10n.orderPlacedOn} ${createdAt.day}/${createdAt.month}/${createdAt.year}';
            } else if (isActive) {
              subtitle =
                  '${l10n.updatedOn} ${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
            } else {
              subtitle = l10n.completed;
            }
          }

          return _buildStatusTile(
            context,
            icon: _getIconForStatus(statusName),
            title: statusName.name.replaceAll('_', ' ').toUpperCase(),
            subtitle: subtitle,
            isFirst: index == 0,
            isLast: index == statuses.length - 1,
            isActive: isActive,
            isCompleted: isCompleted,
            color: isCompleted ? theme.colorScheme.primary : Colors.grey.shade400,
          );
        }),
      ],
    );
  }

  IconData _getIconForStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.hourglass_empty_rounded;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.inProgress:
        return Icons.sync_rounded;
      case OrderStatus.readyForPickup:
        return Icons.inventory_2_outlined;
      case OrderStatus.completed:
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Widget _buildStatusTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isFirst,
    required bool isLast,
    required bool isActive,
    required bool isCompleted,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 1,
                height: 4,
                color: isFirst ? Colors.transparent : color,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isCompleted ? color : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: color, width: 2) : null,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isCompleted ? Colors.white : Colors.grey.shade600,
                ),
              ),
              Expanded(
                child: Container(
                  width: 1,
                  color: isLast ? Colors.transparent : color,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted ? theme.textTheme.bodyLarge?.color : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isCompleted ? theme.textTheme.bodySmall?.color : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderActions extends ConsumerWidget {
  final Order order;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;

  const _OrderActions({
    required this.order,
    required this.isExpanded,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      tooltip: l10n.moreOptionsForOrder(order.trackingId),
      onSelected: (value) {
        switch (value) {
          case 'details':
            onToggleExpansion();
            break;
          case 'cancel':
            _showCancelConfirmation(context, ref);
            break;
          case 'duplicate':
            _duplicateOrder(context, ref);
            break;
          case 'share':
            _shareOrder(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'details',
          child: ListTile(
            leading: Icon(isExpanded ? Icons.visibility_off : Icons.visibility),
            title: Text(isExpanded ? l10n.hideDetails : l10n.viewDetails),
          ),
        ),
        if (order.status != OrderStatus.cancelled && order.status != OrderStatus.completed)
          PopupMenuItem<String>(
            value: 'cancel',
            child: ListTile(
              leading: const Icon(Icons.cancel),
              title: Text(l10n.cancelOrder),
            ),
          ),
        PopupMenuItem<String>(
          value: 'duplicate',
          child: ListTile(
            leading: const Icon(Icons.copy),
            title: Text(l10n.duplicateOrder),
          ),
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: ListTile(
            leading: const Icon(Icons.share),
            title: Text(l10n.shareOrder),
          ),
        ),
      ],
    );
  }

  void _duplicateOrder(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    cartNotifier.clear();

    for (final item in order.items) {
      cartNotifier.toggleService(
        Service(
          id: item.serviceId,
          name: item.serviceName,
          price: item.priceCents / 100,
          category: ServiceCategory.extras,
        ),
      );
    }

    // Assuming you have a route named '/new-order'
    GoRouter.of(context).push('/client/orders/new');
  }

  void _shareOrder(BuildContext context) {
    final items = order.items.map((item) => '  - ${item.serviceName} (x${item.quantity}) - PKR ${item.priceCents.toStringAsFixed(0)}').join('\n');
    final notes = order.notes != null && order.notes!.isNotEmpty ? '\nNotes:\n${order.notes}' : '';

    final shareText = '''
Order Details:
Tracking ID: #${order.trackingId}
Date: ${order.formattedDate}
Total: PKR ${order.totalCents.toStringAsFixed(0)}
Status: ${order.status.name.replaceAll('_', ' ').toUpperCase()}

Items:
$items
$notes
''';

    // ignore: deprecated_member_use
    Share.share(shareText, subject: 'Order Details #${order.trackingId}');
  }

  void _showCancelConfirmation(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isCancelling = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.cancelOrder),
              content: Text(l10n.areYouSureYouWantToCancelThisOrderUndone),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.no),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: isCancelling
                      ? null
                      : () async {
                          setState(() {
                            isCancelling = true;
                          });
                          try {
                            await ref.read(orderRepositoryProvider).cancelOrder(order.id);
                            ref.invalidate(paginatedOrdersProvider);
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.orderSuccessfullyCancelled),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${l10n.errorCancellingOrder} $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: isCancelling
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l10n.yesCancel),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
