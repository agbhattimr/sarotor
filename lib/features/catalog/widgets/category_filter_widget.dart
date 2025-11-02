import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/catalog/catalog_screen.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';

class CategoryFilterWidget extends ConsumerWidget {
  final List<Service>? services;

  const CategoryFilterWidget({
    super.key,
    required this.services,
  });

  List<ServiceCategory?> _extractCategories(List<Service>? services) {
    if (services == null || services.isEmpty) {
      return [null];
    }
    final categories = services
        .map((service) => service.category)
        .toSet()
        .cast<ServiceCategory>()
        .toList();
    return [null, ...categories];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeServices = services ?? [];
    debugPrint('CategoryFilterWidget services length: ${safeServices.length}');
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = _extractCategories(safeServices);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          final count = category == null
              ? safeServices.length
              : safeServices.where((s) => s.category == category).length;

          return GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  '${category?.displayName ?? 'All'} ($count)',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
