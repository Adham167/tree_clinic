import 'package:flutter/material.dart';
import 'package:tree_clinic/core/catalog/tree_disease_catalog.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/add_product_field.dart';

/// Step 2 of the add/edit product flow: price, category, tree, disease.
class TreatmentStep extends StatelessWidget {
  const TreatmentStep({
    super.key,
    required this.formKey,
    required this.priceController,
    required this.customTreeController,
    required this.customDiseaseController,
    required this.categories,
    required this.selectedCategory,
    required this.selectedTree,
    required this.selectedDisease,
    required this.treeOptions,
    required this.diseaseOptions,
    required this.isOtherTreeSelected,
    required this.isOtherDiseaseSelected,
    required this.selectedKnownTree,
    required this.isLoading,
    required this.onCategoryChanged,
    required this.onTreeChanged,
    required this.onDiseaseChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController priceController;
  final TextEditingController customTreeController;
  final TextEditingController customDiseaseController;
  final List<String> categories;
  final String selectedCategory;
  final String? selectedTree;
  final String? selectedDisease;
  final List<String> treeOptions;
  final List<String> diseaseOptions;
  final bool isOtherTreeSelected;
  final bool isOtherDiseaseSelected;
  final String? selectedKnownTree;
  final bool isLoading;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onTreeChanged;
  final ValueChanged<String?> onDiseaseChanged;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          AddProductField(
            controller: priceController,
            label: context.tr('Price'),
            icon: Icons.attach_money,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final price = double.tryParse(value?.trim() ?? '');
              if (price == null || price <= 0) {
                return context.tr('Enter a valid positive price');
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              labelText: context.tr('Category'),
              prefixIcon: const Icon(Icons.category_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(context.tr(category)),
                    ))
                .toList(),
            onChanged: isLoading ? null : onCategoryChanged,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: ValueKey(selectedTree),
            initialValue: selectedTree,
            decoration: InputDecoration(
              labelText: context.tr('Tree'),
              prefixIcon: const Icon(Icons.park_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (_) {
              if ((selectedTree ?? '').trim().isEmpty) {
                return context.tr('Select tree');
              }
              return null;
            },
            items: treeOptions
                .map((tree) => DropdownMenuItem(
                      value: tree,
                      child: Text(context.tr(tree)),
                    ))
                .toList(),
            onChanged: isLoading ? null : onTreeChanged,
          ),
          if (isOtherTreeSelected) ...[
            const SizedBox(height: 12),
            AddProductField(
              controller: customTreeController,
              label: context.tr('Enter a custom tree'),
              icon: Icons.forest_outlined,
              validator: (value) {
                final rawValue = value?.trim() ?? '';
                if (rawValue.isEmpty) {
                  return context.tr('This field is required');
                }
                if (TreeDiseaseCatalog.containsTree(rawValue)) {
                  return context.tr(
                    'This tree already exists in the list. Please choose it from the list.',
                  );
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AddProductField(
              controller: customDiseaseController,
              label: context.tr('Enter a custom disease'),
              icon: Icons.spa_outlined,
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return context.tr('Disease is required');
                }
                return null;
              },
            ),
          ] else if (selectedKnownTree != null) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey('${selectedTree}_$selectedDisease'),
              initialValue: selectedDisease,
              decoration: InputDecoration(
                labelText: context.tr('Disease'),
                prefixIcon: const Icon(Icons.spa_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (_) {
                if ((selectedDisease ?? '').trim().isEmpty) {
                  return context.tr('Select disease');
                }
                return null;
              },
              items: diseaseOptions
                  .map((disease) => DropdownMenuItem(
                        value: disease,
                        child: Text(context.tr(disease)),
                      ))
                  .toList(),
              onChanged: isLoading ? null : onDiseaseChanged,
            ),
            if (isOtherDiseaseSelected) ...[
              const SizedBox(height: 12),
              AddProductField(
                controller: customDiseaseController,
                label: context.tr('Enter a custom disease'),
                icon: Icons.edit_note_outlined,
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return context.tr('Disease is required');
                  }
                  return null;
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
} 