import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class RelatedProductCard extends StatelessWidget {
  final ProductModel product;

  const RelatedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(
          context,
        ).pushReplacement(AppRouter.kProductDetailsView, extra: product);
      },
      child: SizedBox(
        width: 160,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text("${product.price} EGP"),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
