import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/features/orders/widgets/service_grid.dart';

class ServiceSelectionStep extends ConsumerStatefulWidget {
  const ServiceSelectionStep({super.key});

  @override
  ConsumerState<ServiceSelectionStep> createState() => _ServiceSelectionStepState();
}

class _ServiceSelectionStepState extends ConsumerState<ServiceSelectionStep>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<ServiceCategory> _categories = [];
  bool _isLoading = true;
  String _error = '';

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCategories();
      }
    });
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchTerm = _searchController.text;
        });
      }
    });
  }

  Future<void> _loadCategories() async {
    try {
      final categories =
          await ref.read(serviceRepositoryProvider).getServiceCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _tabController =
              TabController(length: _categories.length, vsync: this);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load services: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }
    if (_categories.isEmpty) {
      return const Center(child: Text('No service categories found.'));
    }

    final cart = ref.watch(cartProvider);

    return Column(
      children: [
        SwitchListTile(
          title: const Text('Urgent Delivery'),
          subtitle: const Text('50% surcharge will be applied'),
          value: cart.isUrgentDelivery,
          onChanged: (value) {
            ref.read(cartProvider.notifier).toggleUrgentDelivery(value);
          },
        ),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((c) => Tab(text: c.name)).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _categories.map((category) {
              if (category.name == "Men's Wear") {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.construction, size: 50, color: Colors.grey),
                      SizedBox(height: 16),
                      Text("Coming Soon!", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }
              return ServiceGrid(
                categoryId: category.index,
                searchTerm: _searchTerm,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
