import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/cart/presentation/cart_page.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_product_cubit/get_product_cubit.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_product_cubit/get_prouct_state.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/product_card.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetProductsCubit()..fetchAllProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Shop"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search treatments...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            SizedBox(
              height: 50,
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

            Expanded(
              child: BlocBuilder<GetProductsCubit, GetProductsState>(
                builder: (context, state) {
                  if (state is GetProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is GetProductsFailure) {
                    return Center(child: Text(state.errMessage));
                  }

                  if (state is GetProductsSuccess) {
                    var products = state.products;

                    if (selectedCategory != "All") {
                      products = products
                          .where((p) => p.category == selectedCategory)
                          .toList();
                    }

                    if (searchController.text.isNotEmpty) {
                      products = products
                          .where((p) => p.name
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase()))
                          .toList();
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FilterChip(
        label: Text(label),
        selected: selectedCategory == label,
        onSelected: (val) {
          setState(() => selectedCategory = label);
        },
        selectedColor: Colors.green,
      ),
    );
  }
}