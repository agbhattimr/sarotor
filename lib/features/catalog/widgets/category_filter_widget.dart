import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/catalog/catalog_screen.dart';
import 'package:sartor_order_management/models/service.dart';
import 'package:sartor_order_management/models/service_category.dart';

class CategoryFilterWidget extends ConsumerWidget {
  final List<Service> services;

  const CategoryFilterWidget({
    super.key,
    required this.services,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = [null, ...ServiceCategory.values]; // Add 'All' category

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
              ? services.length
              : services.where((s) => s.category == category).length;

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
                  '${category?.name ?? 'All'} ($count)',
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
