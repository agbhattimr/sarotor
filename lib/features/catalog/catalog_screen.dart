import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/models/service_category.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/features/admin/add_edit_service_screen.dart';
import 'package:sartor_order_management/features/catalog/widgets/service_card.dart';
import 'package:sartor_order_management/features/catalog/widgets/category_filter_widget.dart';
import 'package:sartor_order_management/shared/components/responsive_layout.dart';

final selectedCategoryProvider = StateProvider<ServiceCategory?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(allServicesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sartor Services'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white30,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading services',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(allServicesProvider),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
        data: (services) {
          final filteredServices = services.where((service) {
            final categoryMatch =
                selectedCategory == null || service.category == selectedCategory;
            final searchMatch = searchQuery.isEmpty ||
                (service.name ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                (service.description ?? '')
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
            return categoryMatch && searchMatch;
          }).toList();

          return Column(
            children: [
              CategoryFilterWidget(services: services),
              Expanded(
                child: filteredServices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isNotEmpty || selectedCategory != null
                                  ? 'No services match your criteria'
                                  : 'No services available',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : _buildResponsiveGridView(filteredServices),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditServiceScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Service',
      ),
    );
  }

  Widget _buildResponsiveGridView(List<dynamic> services) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth >= 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 600) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }
        return _buildGridView(services, crossAxisCount);
      },
    );
  }

  Widget _buildGridView(List<dynamic> services, int crossAxisCount) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return ServiceCard(
          service: service,
          onEdit: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditServiceScreen(service: service),
              ),
            );
          },
        );
      },
    );
  }
}
