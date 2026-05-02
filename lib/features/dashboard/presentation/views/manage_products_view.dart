import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_product_cubit/add_product_cubit.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class ManageProductsView extends StatelessWidget {
  const ManageProductsView({super.key, required this.shop});

  final ShopEntity shop;

  String _displayLabel(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    return context.tr(trimmed);
  }

  Future<void> _deleteProduct(
    BuildContext context,
    ProductModel product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(dialogContext.tr('Delete product')),
            content: Text(
              dialogContext.tr(
                'Delete {name}? This action cannot be undone.',
                params: {'name': product.name},
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(dialogContext.tr('Cancel')),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                icon: const Icon(Icons.delete),
                label: Text(dialogContext.tr('Delete')),
              ),
            ],
          ),
    );

    if (confirmed != true || !context.mounted) return;
    context.read<AddProductCubit>().deleteProduct(product.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.tr(state.message))));
        } else if (state is AddProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr(state.errMessage)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(context.tr('Manage Products')),
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () => context.push(AppRouter.kaddProductView),
          icon: const Icon(Icons.add),
          label: Text(context.tr('Add Product')),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance
                  .collection('products')
                  .where('shopId', isEqualTo: shop.id)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final products =
                snapshot.data!.docs
                    .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
                    .toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (products.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.green.shade600,
                        size: 58,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.tr('No products yet'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr(
                          'Add treatments and supplies so farmers can find them in the shop.',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                return _ProductManagerTile(
                  product: product,
                  treeLabel: _displayLabel(context, product.tree),
                  diseaseLabel: _displayLabel(context, product.disease),
                  categoryLabel: _displayLabel(context, product.category),
                  onEdit:
                      () => context.push(
                        AppRouter.kaddProductView,
                        extra: product,
                      ),
                  onDelete: () => _deleteProduct(context, product),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProductManagerTile extends StatelessWidget {
  const _ProductManagerTile({
    required this.product,
    required this.treeLabel,
    required this.diseaseLabel,
    required this.categoryLabel,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductModel product;
  final String treeLabel;
  final String diseaseLabel;
  final String categoryLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 78,
              height: 78,
              child:
                  product.image.trim().isEmpty
                      ? const _ProductImageFallback()
                      : Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const _ProductImageFallback(),
                      ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _InfoChip(
                      label: '${product.price} ${context.tr('EGP')}',
                    ),
                    _InfoChip(label: categoryLabel),
                    _InfoChip(label: treeLabel),
                    _InfoChip(label: diseaseLabel),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                tooltip: context.tr('Edit'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.green),
              ),
              IconButton(
                tooltip: context.tr('Delete'),
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    if (label.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withValues(alpha: 0.08),
      child: const Icon(Icons.inventory_2_outlined, color: Colors.green),
    );
  }
}
