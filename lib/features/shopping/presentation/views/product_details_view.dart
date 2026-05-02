import 'package:flutter/material.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.image, size: 60)),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "${product.price.toStringAsFixed(2)} EGP",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.green, // نفس الشوب
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Chips
                  Wrap(
                    spacing: 8,
                    children: [
                      _chip(product.category),
                      _chip(product.tree),
                      _chip(product.disease),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  _sectionTitle("Description"),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info Card
                  _infoCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.green.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(color: Colors.green.withOpacity(0.3)), // ✨ NEW
    );
  }

  Widget _sectionTitle(String title) {
    return const Text(
      "Description",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Product Info",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green, // ✨ NEW
            ),
          ),
          const SizedBox(height: 12),
          _rowInfo("Tree", product.tree),
          _rowInfo("Disease", product.disease),
          _rowInfo("Category", product.category),
          _rowInfo(
            "Created At",
            product.createdAt.toString().split(" ").first,
          ),
        ],
      ),
    );
  }

  Widget _rowInfo(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}