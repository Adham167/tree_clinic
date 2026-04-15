import 'package:flutter/material.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';

class MyShopView extends StatelessWidget {
  final ShopEntity shop;

  const MyShopView({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shop.name),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shop.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(shop.description),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 5),
                Text(shop.address),
              ],
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Edit Shop"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}