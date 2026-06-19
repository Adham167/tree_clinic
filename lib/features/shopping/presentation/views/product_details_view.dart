import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_related_products_cubit/get_related_products_cubit.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/chip_widget.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/info_card_widget.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/related_products_section.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/section_title.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              GetRelatedProductsCubit()..fetchRelatedProducts(
                treeName: product.tree,
                currentProductId: product.id,
              ),
      child: Scaffold(
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
                    errorBuilder:
                        (_, __, ___) => const Center(
                          child: Icon(Icons.image, size: 60),
                        ),
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
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 12),
        
                    Wrap(
                      spacing: 8,
                      children: [
                        ChipWidget(label: product.category),
                        ChipWidget(label: product.tree),
                        ChipWidget(label: product.disease),
                      ],
                    ),
        
                    const SizedBox(height: 20),
        
                    SectionTitle(title: "Description"),
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
        
                    InfoCardWidget(product: product),
                    RelatedProductsSection()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
