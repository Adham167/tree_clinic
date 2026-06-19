import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_related_products_cubit/get_related_products_cubit.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/related_product_card.dart';
import 'package:tree_clinic/features/shopping/presentation/views/widgets/section_title.dart';

class RelatedProductsSection extends StatelessWidget {
  const RelatedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRelatedProductsCubit, GetRelatedProductsState>(
      builder: (context, state) {
        if (state is GetRelatedProductsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetRelatedProductsFailure) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Text(state.errMessage),
          );
        }

        if (state is GetRelatedProductsSuccess) {
          if (state.products.isEmpty) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              SectionTitle(title: "Related Products"),

              const SizedBox(height: 12),

              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = state.products[index];

                    return RelatedProductCard(product: product);
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
