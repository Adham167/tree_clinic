import 'package:flutter/material.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/product_card.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key, required this.prediction});

  final PredictionModel prediction;

  @override
  Widget build(BuildContext context) {
    final List<String> products = [
      ...prediction.chemical,
      ...prediction.organic,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommended Treatment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search treatment...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Grid
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: .75,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    title: products[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}