import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sartor_order_management/features/orders/widgets/empty_state_widget.dart';
import 'package:sartor_order_management/features/orders/widgets/service_grid_shimmer.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/shared/components/service_card.dart';
import 'package:sartor_order_management/shared/components/order_card.dart';

class ServiceGrid extends ConsumerWidget {
  final int categoryId;
  final String searchTerm;

  const ServiceGrid({
    super.key,
    required this.categoryId,
    this.searchTerm = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesFuture = ref.watch(servicesProvider(categoryId));

    return servicesFuture.when(
      data: (services) {
        if (services.isEmpty) {
          return const EmptyStateWidget(
            // TODO: Replace with assets/images/empty_box.svg
            assetName: 'assets/images/empty_box.svg',
            title: 'No Services Available',
            message: 'There are currently no services in this category.',
          );
        }

        final filteredServices = services
            .where((s) =>
                (s.name ?? '').toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();

        if (filteredServices.isEmpty) {
          return const EmptyStateWidget(
            // TODO: Replace with assets/images/no_results.svg
            assetName: 'assets/images/no_results.svg',
            title: 'No Results Found',
            message: 'Your search did not match any services.',
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            return ServiceCard(
              service: filteredServices[index],
              appContext: AppContext.client,
            );
          },
        );
      },
      loading: () => const ServiceGridShimmer(),
      error: (err, stack) => EmptyStateWidget(
        // TODO: Replace with assets/images/error.svg
        assetName: 'assets/images/error.svg',
        title: 'Something Went Wrong',
        message: 'We couldn\'t load the services. Please try again.',
        onRetry: () => ref.invalidate(servicesProvider(categoryId)),
      ),
    );
  }
}
