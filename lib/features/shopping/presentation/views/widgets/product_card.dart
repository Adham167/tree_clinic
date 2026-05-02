import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/cart/data/model/cart_item.dart';
import 'package:tree_clinic/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductModel product;

  String _displayLabel(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    return context.tr(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final treeLabel = _displayLabel(context, product.tree);
    final diseaseLabel = _displayLabel(context, product.disease);

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kProductDetailsView);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child:
                    product.image.trim().isEmpty
                        ? const _ProductImageFallback()
                        : Image.network(
                          product.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const _ProductImageFallback(),
                        ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (treeLabel.isNotEmpty || diseaseLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (treeLabel.isNotEmpty)
                      _ProductInfoChip(label: treeLabel),
                    if (diseaseLabel.isNotEmpty)
                      _ProductInfoChip(label: diseaseLabel),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${product.price} ${context.tr('EGP')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    color: Colors.green,
                    onPressed: () {
                      final cartItem = CartItem(
                        id: product.id,
                        name: product.name,
                        price: product.price,
                        image: product.image,
                        shopId: product.shopId,
                        tree: product.tree,
                        disease: product.disease,
                        quantity: 1,
                      );
                      context.read<CartCubit>().addItem(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.tr('Added to cart'))),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductInfoChip extends StatelessWidget {
  const _ProductInfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(Icons.inventory_2_outlined, color: Colors.green, size: 42),
      ),
    );
  }
}
