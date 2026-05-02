import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
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
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GetProductsCubit>().fetchAllProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('Shop')),
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
                hintText: context.tr('Search treatments...'),
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
                _filterChip('All'),
                _filterChip('Fungicide'),
                _filterChip('Insecticide'),
                _filterChip('Fertilizer'),
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

                  if (selectedCategory != 'All') {
                    products =
                        products
                            .where((product) => product.category == selectedCategory)
                            .toList();
                  }

                  if (searchController.text.isNotEmpty) {
                    final query = searchController.text.toLowerCase();
                    products =
                        products.where((product) {
                          return product.name.toLowerCase().contains(query) ||
                              product.tree.toLowerCase().contains(query) ||
                              product.disease.toLowerCase().contains(query) ||
                              product.category.toLowerCase().contains(query);
                        }).toList();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.72,
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
    );
  }

  Widget _filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: FilterChip(
        label: Text(context.tr(label)),
        selected: selectedCategory == label,
        onSelected: (_) {
          setState(() => selectedCategory = label);
        },
        selectedColor: Colors.green,
      ),
    );
  }
}
