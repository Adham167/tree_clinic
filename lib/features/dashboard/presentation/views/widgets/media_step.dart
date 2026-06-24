import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/add_product_field.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/add_product_image_preview.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/add_product_summary_row.dart';

/// Step 3 of the add/edit product flow: image URL + summary.
class MediaStep extends StatelessWidget {
  const MediaStep({
    super.key,
    required this.formKey,
    required this.imageController,
    required this.onImageChanged,
    required this.displayName,
    required this.displayCategory,
    required this.displayTree,
    required this.displayDisease,
    required this.priceText,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController imageController;
  final VoidCallback onImageChanged;
  final String displayName;
  final String displayCategory;
  final String displayTree;
  final String displayDisease;
  final String priceText;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddProductField(
            controller: imageController,
            label: context.tr('Image URL (optional)'),
            icon: Icons.image_outlined,
            keyboardType: TextInputType.url,
            onChanged: (_) => onImageChanged(),
            validator: (value) {
              final rawValue = value?.trim() ?? '';
              if (rawValue.isEmpty) return null;

              final uri = Uri.tryParse(rawValue);
              if (uri == null || uri.host.isEmpty) {
                return context.tr('Enter a valid image URL');
              }
              if (uri.scheme != 'http' && uri.scheme != 'https') {
                return context.tr('Image URL must start with http or https');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AddProductImagePreview(url: imageController.text.trim()),
          const SizedBox(height: 16),
          AddProductSummaryRow(label: context.tr('Name'), value: displayName),
          AddProductSummaryRow(
            label: context.tr('Category'),
            value: displayCategory,
          ),
          AddProductSummaryRow(label: context.tr('Tree'), value: displayTree),
          AddProductSummaryRow(
            label: context.tr('Disease'),
            value: displayDisease,
          ),
          AddProductSummaryRow(
            label: context.tr('Price'),
            value: priceText.isEmpty ? '-' : '$priceText ${context.tr('EGP')}',
          ),
        ],
      ),
    );
  }
}