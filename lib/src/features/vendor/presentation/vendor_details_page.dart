import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../vendor/data/vendor_model.dart';
import '../../product/data/product_repository.dart';
import '../../product/data/product_model.dart';
import '../../order/presentation/cart_notifier.dart';
import '../../order/presentation/cart_page.dart';

final vendorProductsProvider = FutureProvider.family<List<Product>, int>((ref, vendorId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProducts(vendorId: vendorId);
});

class VendorDetailsPage extends ConsumerWidget {
  final Vendor vendor;

  const VendorDetailsPage({super.key, required this.vendor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(vendorProductsProvider(vendor.id));
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(vendor.name),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.totalItems}'),
              isLabelVisible: cart.isNotEmpty,
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Vendor Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vendor.profileImageUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        vendor.profileImageUrl!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.store, size: 48),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  vendor.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (vendor.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    vendor.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (vendor.openingTime != null && vendor.closeTime != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 8),
                      Text('${vendor.openingTime} - ${vendor.closeTime}'),
                    ],
                  ),
                ],
                if (vendor.type != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 16),
                      const SizedBox(width: 8),
                      Text(vendor.type!),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Products Section
          Expanded(
            child: productsState.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No products available'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: product.imageUrl != null
                                ? Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.shopping_bag, size: 48),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.shopping_bag, size: 48),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (product.hasDiscount) ...[
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Text(
                                    '\$${product.effectivePrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ] else
                                  Text(
                                    '\$${product.effectivePrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (!product.isAvailable) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Out of Stock',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final cartNotifier = ref.read(cartProvider.notifier);
                                final quantity = ref.watch(cartProvider).items[product.id]?.quantity ?? 0;

                                if (quantity == 0) {
                                  return ElevatedButton.icon(
                                    onPressed: product.isAvailable
                                        ? () {
                                            try {
                                              cartNotifier.addItem(product);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${product.name} added to cart'),
                                                  duration: const Duration(seconds: 1),
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString().replaceAll('Exception: ', '')),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                                    label: const Text('Add'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(32),
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 32,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => cartNotifier.decrementQuantity(product.id),
                                            icon: const Icon(Icons.remove_circle_outline),
                                            iconSize: 20,
                                          ),
                                        ),
                                        Text(
                                          '$quantity',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => cartNotifier.incrementQuantity(product.id),
                                            icon: const Icon(Icons.add_circle_outline),
                                            iconSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading products: ${error.toString()}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
