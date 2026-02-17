import 'package:flutter/material.dart';
import 'main_navigation.dart';
import '../features/cart/presentation/cart_page.dart';

class ShopPage extends StatelessWidget {
  final products = [];

   ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop"),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            MainNavigation.of(context)?.goToHome();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
