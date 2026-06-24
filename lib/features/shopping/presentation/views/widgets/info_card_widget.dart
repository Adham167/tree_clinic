import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/row_info_widget.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Product Info'),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 12),

          RowInfoWidget(kkey: "Tree", value: product.tree),

          RowInfoWidget(kkey: "Disease", value: product.disease),

          RowInfoWidget(kkey: "Category", value: product.category),

          RowInfoWidget(
            kkey: "Created At",
            value: product.createdAt.toString().split(" ").first,
          ),
        ],
      ),
    );
  }
}
