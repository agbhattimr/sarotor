import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:sartor_order_management/providers/cart_provider.dart';
import 'package:sartor_order_management/providers/measurements_provider.dart';
import 'package:sartor_order_management/services/service_repository.dart';
import 'package:sartor_order_management/models/cart.dart';
import 'package:sartor_order_management/models/measurement.dart';
import 'dart:io';

class NewOrderNotesScreen extends ConsumerWidget {
  const NewOrderNotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final measurementsAsync = ref.watch(measurementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes and Images'),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('No services selected'))
          : measurementsAsync.when(
              data: (measurements) => ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items.values.elementAt(index);
                  return _buildServiceNotesCard(context, ref, item, cartNotifier, measurements);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading measurements: $err')),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'new_order_notes_fab',
        onPressed: () {
          context.push('/client/orders/new/customer-details');
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildServiceNotesCard(BuildContext context, WidgetRef ref, CartItem item, CartNotifier cartNotifier, List<Measurement> measurements) {
    final serviceAsync = ref.watch(serviceByIdProvider(item.serviceId));

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: serviceAsync.when(
                    data: (service) {
                      if (service?.imageUrl != null && service!.imageUrl!.isNotEmpty) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            service.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.shopping_bag, size: 30),
                          ),
                        );
                      } else {
                        return const Icon(Icons.shopping_bag, size: 30);
                      }
                    },
                    loading: () => const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                    error: (err, stack) => const Icon(Icons.error, size: 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: item.notes),
              onChanged: (value) {
                final update = CartItemUpdate(notes: value);
                cartNotifier.updateItem(item.id, update);
              },
              decoration: const InputDecoration(
                labelText: 'Service-specific notes',
                border: OutlineInputBorder(),
                hintText: 'Any special requirements for this service?',
              ),
              textDirection: TextDirection.ltr, // Force LTR for notes (even in RTL languages)
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Attach Measurement Profile',
                border: OutlineInputBorder(),
                hintText: 'Select a measurement profile for this service',
              ),
              initialValue: item.measurementProfileId,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('No measurement profile'),
                ),
                ...measurements.map((measurement) => DropdownMenuItem<String>(
                  value: measurement.id,
                  child: Text(measurement.name),
                )),
              ],
              onChanged: (value) {
                final update = CartItemUpdate(measurementProfileId: value);
                cartNotifier.updateItem(item.id, update);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null && context.mounted) {
                        final currentUrls = item.imageUrls ?? [];
                        final newUrls = [...currentUrls, pickedFile.path];
                        final update = CartItemUpdate(imageUrls: newUrls);
                        cartNotifier.updateItem(item.id, update);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to pick image: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Image'),
                ),
                const SizedBox(width: 16),
                Text(
                  '${item.imageUrls?.length ?? 0} images',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (item.imageUrls != null && item.imageUrls!.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.imageUrls!.length,
                  itemBuilder: (context, imageIndex) {
                    final imageUrl = item.imageUrls![imageIndex];
                    return Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(imageUrl),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  final currentUrls = item.imageUrls ?? [];
                                  final newUrls = [...currentUrls]..removeAt(imageIndex);
                                  final update = CartItemUpdate(imageUrls: newUrls);
                                  cartNotifier.updateItem(item.id, update);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
