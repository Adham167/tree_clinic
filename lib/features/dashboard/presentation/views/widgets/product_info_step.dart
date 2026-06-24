import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/add_product_field.dart';

/// Step 1 of the add/edit product flow: bilingual name + description.
class ProductInfoStep extends StatelessWidget {
  const ProductInfoStep({
    super.key,
    required this.formKey,
    required this.nameEnController,
    required this.nameArController,
    required this.descEnController,
    required this.descArController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameEnController;
  final TextEditingController nameArController;
  final TextEditingController descEnController;
  final TextEditingController descArController;

  String? _validateName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('Product name is required');
    }
    if (value.trim().length < 3) {
      return context.tr('Use at least 3 characters');
    }
    return null;
  }

  String? _validateDescription(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.tr('Description is required');
    }
    if (value.trim().length < 10) {
      return context.tr('Add a clearer description');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          AddProductField(
            controller: nameEnController,
            label: 'Product Name (English)',
            icon: Icons.inventory_2_outlined,
            textDirection: TextDirection.ltr,
            validator: (value) => _validateName(context, value),
          ),
          const SizedBox(height: 12),
          AddProductField(
            controller: nameArController,
            label: 'اسم المنتج بالعربية',
            icon: Icons.inventory_2_outlined,
            textDirection: TextDirection.rtl,
            validator: (value) => _validateName(context, value),
          ),
          const SizedBox(height: 12),
          AddProductField(
            controller: descEnController,
            label: 'Description (English)',
            icon: Icons.description_outlined,
            maxLines: 3,
            textDirection: TextDirection.ltr,
            validator: (value) => _validateDescription(context, value),
          ),
          const SizedBox(height: 12),
          AddProductField(
            controller: descArController,
            label: 'الوصف بالعربية',
            icon: Icons.description_outlined,
            maxLines: 3,
            textDirection: TextDirection.rtl,
            validator: (value) => _validateDescription(context, value),
          ),
        ],
      ),
    );
  }
}