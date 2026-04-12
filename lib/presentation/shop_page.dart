import 'package:flutter/material.dart';
import 'package:tree_clinic/features/cart/presentation/cart_page.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/list_products.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/product_card.dart';
import 'package:tree_clinic/presentation/main_navigation.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            MainNavigation.of(context)?.goToHome();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          /// Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search treatments...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          /// Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip("All"),
                _filterChip("Fungicide"),
                _filterChip("Insecticide"),
                _filterChip("Fertilizer"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// Grid View
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .75,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Chip(label: Text(label), backgroundColor: Colors.green.shade100),
    );
  }
}
