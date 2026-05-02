import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/core/catalog/tree_disease_catalog.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button2.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_product_cubit/add_product_cubit.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key, this.initialProduct});

  final ProductModel? initialProduct;

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _productFormKey = GlobalKey<FormState>();
  final _treatmentFormKey = GlobalKey<FormState>();
  final _mediaFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  final customTreeController = TextEditingController();
  final customDiseaseController = TextEditingController();

  final categories = const ['Fungicide', 'Insecticide', 'Fertilizer'];
  String selectedCategory = 'Fungicide';
  String? selectedTree;
  String? selectedDisease;
  int currentStep = 0;

  bool get isEditing => widget.initialProduct != null;
  bool get _isOtherTreeSelected => selectedTree == TreeDiseaseCatalog.otherOption;
  bool get _isOtherDiseaseSelected =>
      selectedDisease == TreeDiseaseCatalog.otherOption;

  String? get _selectedKnownTree {
    if (selectedTree == null || _isOtherTreeSelected) return null;
    return selectedTree;
  }

  List<String> get _treeOptions => [
    ...TreeDiseaseCatalog.treeNames,
    TreeDiseaseCatalog.otherOption,
  ];

  List<String> get _diseaseOptions {
    final knownTree = _selectedKnownTree;
    if (knownTree == null) return const [];
    return [
      ...TreeDiseaseCatalog.diseasesFor(knownTree),
      TreeDiseaseCatalog.otherOption,
    ];
  }

  String get _resolvedTree {
    if (_isOtherTreeSelected) {
      return customTreeController.text.trim();
    }
    return selectedTree?.trim() ?? '';
  }

  String get _resolvedDisease {
    if (_isOtherTreeSelected || _isOtherDiseaseSelected) {
      return customDiseaseController.text.trim();
    }
    return selectedDisease?.trim() ?? '';
  }

  @override
  void initState() {
    super.initState();
    final product = widget.initialProduct;
    if (product == null) return;

    nameController.text = product.name;
    descController.text = product.description;
    priceController.text = product.price.toStringAsFixed(
      product.price.truncateToDouble() == product.price ? 0 : 2,
    );
    imageController.text = product.image;

    if (categories.contains(product.category)) {
      selectedCategory = product.category;
    }

    final savedTree = product.tree.trim();
    final savedDisease = product.disease.trim();

    if (savedTree.isNotEmpty && TreeDiseaseCatalog.containsTree(savedTree)) {
      selectedTree = TreeDiseaseCatalog.findTree(savedTree)?.treeName;
      if (selectedTree != null &&
          TreeDiseaseCatalog.containsDiseaseForTree(selectedTree!, savedDisease)) {
        selectedDisease = TreeDiseaseCatalog.diseasesFor(
          selectedTree!,
        ).firstWhere(
          (disease) =>
              TreeDiseaseCatalog.normalize(disease) ==
              TreeDiseaseCatalog.normalize(savedDisease),
        );
      } else if (savedDisease.isNotEmpty) {
        selectedDisease = TreeDiseaseCatalog.otherOption;
        customDiseaseController.text = savedDisease;
      }
    } else if (savedTree.isNotEmpty || savedDisease.isNotEmpty) {
      selectedTree = TreeDiseaseCatalog.otherOption;
      customTreeController.text = savedTree;
      customDiseaseController.text = savedDisease;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    imageController.dispose();
    customTreeController.dispose();
    customDiseaseController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_validateAllSteps()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final messageKey =
            isEditing
                ? 'Update {name} as a {category} product?'
                : 'Add {name} as a {category} product?';

        return AlertDialog(
          title: Text(context.tr('Confirm product')),
          content: Text(
            context.tr(
              messageKey,
              params: {
                'name': nameController.text.trim(),
                'category': context.tr(selectedCategory),
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.tr('Review')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.tr(isEditing ? 'Update' : 'Add')),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final price = double.tryParse(priceController.text.trim());
    if (price == null) return;

    if (isEditing) {
      final product = widget.initialProduct!;
      context.read<AddProductCubit>().updateProduct(
        product.copyWith(
          name: nameController.text.trim(),
          description: descController.text.trim(),
          image: imageController.text.trim(),
          price: price,
          tree: _resolvedTree,
          disease: _resolvedDisease,
          category: selectedCategory,
        ),
      );
    } else {
      context.read<AddProductCubit>().addProduct(
        name: nameController.text.trim(),
        description: descController.text.trim(),
        image: imageController.text.trim(),
        price: price,
        tree: _resolvedTree,
        disease: _resolvedDisease,
        category: selectedCategory,
      );
    }
  }

  void _continue() {
    FocusScope.of(context).unfocus();
    if (!_validateStep(currentStep)) return;
    if (currentStep < 2) {
      setState(() => currentStep += 1);
    } else {
      _confirmAndSubmit();
    }
  }

  void _cancel() {
    FocusScope.of(context).unfocus();
    if (currentStep > 0) {
      setState(() => currentStep -= 1);
    } else {
      context.pop();
    }
  }

  bool _validateStep(int step) {
    return switch (step) {
      0 => _productFormKey.currentState?.validate() ?? false,
      1 => _treatmentFormKey.currentState?.validate() ?? false,
      2 => _mediaFormKey.currentState?.validate() ?? false,
      _ => false,
    };
  }

  bool _validateAllSteps() {
    final productValid = _productFormKey.currentState?.validate() ?? false;
    final treatmentValid = _treatmentFormKey.currentState?.validate() ?? false;
    final mediaValid = _mediaFormKey.currentState?.validate() ?? false;

    if (!productValid) {
      setState(() => currentStep = 0);
      return false;
    }
    if (!treatmentValid) {
      setState(() => currentStep = 1);
      return false;
    }
    if (!mediaValid) {
      setState(() => currentStep = 2);
      return false;
    }
    return true;
  }

  void _onTreeChanged(String? value) {
    setState(() {
      selectedTree = value;
      selectedDisease = null;
      customDiseaseController.clear();
      if (value != TreeDiseaseCatalog.otherOption) {
        customTreeController.clear();
      }
    });
  }

  String _displayValue(BuildContext context, String rawValue) {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return '-';
    return context.tr(trimmed);
  }

  String _localizeStateMessage(BuildContext context, String message) {
    const shopFailurePrefix = 'Could not load your shop: ';
    if (message.startsWith(shopFailurePrefix)) {
      return context.tr(
        'Could not load your shop: {message}',
        params: {'message': message.substring(shopFailurePrefix.length)},
      );
    }
    return context.tr(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(context.tr(isEditing ? 'Edit Product' : 'Add Product')),
        backgroundColor: Colors.green,
      ),
      body: BlocConsumer<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddProductSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_localizeStateMessage(context, state.message))),
            );
            context.pop();
          }

          if (state is AddProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _localizeStateMessage(context, state.errMessage),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AddProductLoading;

          return Stepper(
            currentStep: currentStep,
            onStepTapped:
                isLoading
                    ? null
                    : (step) {
                      if (step <= currentStep || _validateStep(currentStep)) {
                        setState(() => currentStep = step);
                      }
                    },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomReactiveButton2(
                        title: context.tr(
                          currentStep == 2 ? 'Review & Add' : 'Next',
                        ),
                        color: Colors.green,
                        isLoading: isLoading,
                        onPressed: _continue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: isLoading ? null : _cancel,
                      child: Text(
                        context.tr(currentStep == 0 ? 'Cancel' : 'Back'),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text(context.tr('Product')),
                isActive: currentStep >= 0,
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                content: Form(
                  key: _productFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      _Field(
                        controller: nameController,
                        label: context.tr('Product Name'),
                        icon: Icons.inventory_2_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.tr('Product name is required');
                          }
                          if (value.trim().length < 3) {
                            return context.tr('Use at least 3 characters');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        controller: descController,
                        label: context.tr('Description'),
                        icon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.tr('Description is required');
                          }
                          if (value.trim().length < 10) {
                            return context.tr('Add a clearer description');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                title: Text(context.tr('Treatment')),
                isActive: currentStep >= 1,
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
                content: Form(
                  key: _treatmentFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      _Field(
                        controller: priceController,
                        label: context.tr('Price'),
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(context.tr(category)),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            isLoading
                                ? null
                                : (value) {
                                  if (value != null) {
                                    setState(() => selectedCategory = value);
                                  }
                                },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        key: ValueKey(selectedTree),
                        initialValue: selectedTree,
                        decoration: InputDecoration(
                          labelText: context.tr('Tree'),
                          prefixIcon: const Icon(Icons.park_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (_) {
                          if ((selectedTree ?? '').trim().isEmpty) {
                            return context.tr('Select tree');
                          }
                          return null;
                        },
                        items:
                            _treeOptions
                                .map(
                                  (tree) => DropdownMenuItem(
                                    value: tree,
                                    child: Text(context.tr(tree)),
                                  ),
                                )
                                .toList(),
                        onChanged: isLoading ? null : _onTreeChanged,
                      ),
                      if (_isOtherTreeSelected) ...[
                        const SizedBox(height: 12),
                        _Field(
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
                        _Field(
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
                      ] else if (_selectedKnownTree != null) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          key: ValueKey('${selectedTree}_$selectedDisease'),
                          initialValue: selectedDisease,
                          decoration: InputDecoration(
                            labelText: context.tr('Disease'),
                            prefixIcon: const Icon(Icons.spa_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (_) {
                            if ((selectedDisease ?? '').trim().isEmpty) {
                              return context.tr('Select disease');
                            }
                            return null;
                          },
                          items:
                              _diseaseOptions
                                  .map(
                                    (disease) => DropdownMenuItem(
                                      value: disease,
                                      child: Text(context.tr(disease)),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              isLoading
                                  ? null
                                  : (value) {
                                    setState(() {
                                      selectedDisease = value;
                                      if (value != TreeDiseaseCatalog.otherOption) {
                                        customDiseaseController.clear();
                                      }
                                    });
                                  },
                        ),
                        if (_isOtherDiseaseSelected) ...[
                          const SizedBox(height: 12),
                          _Field(
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
                ),
              ),
              Step(
                title: Text(context.tr('Media')),
                isActive: currentStep >= 2,
                content: Form(
                  key: _mediaFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Field(
                        controller: imageController,
                        label: context.tr('Image URL (optional)'),
                        icon: Icons.image_outlined,
                        keyboardType: TextInputType.url,
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          final rawValue = value?.trim() ?? '';
                          if (rawValue.isEmpty) return null;

                          final uri = Uri.tryParse(rawValue);
                          if (uri == null || uri.host.isEmpty) {
                            return context.tr('Enter a valid image URL');
                          }
                          if (uri.scheme != 'http' && uri.scheme != 'https') {
                            return context.tr(
                              'Image URL must start with http or https',
                            );
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _ImagePreview(url: imageController.text.trim()),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        label: context.tr('Name'),
                        value: nameController.text,
                      ),
                      _SummaryRow(
                        label: context.tr('Category'),
                        value: _displayValue(context, selectedCategory),
                      ),
                      _SummaryRow(
                        label: context.tr('Tree'),
                        value: _displayValue(context, _resolvedTree),
                      ),
                      _SummaryRow(
                        label: context.tr('Disease'),
                        value: _displayValue(context, _resolvedDisease),
                      ),
                      _SummaryRow(
                        label: context.tr('Price'),
                        value: priceController.text.trim().isEmpty
                            ? '-'
                            : '${priceController.text.trim()} ${context.tr('EGP')}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const _ImagePlaceholder();
    }

    final uri = Uri.tryParse(url);
    final canPreview =
        uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child:
            canPreview
                ? Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Center(
                        child: Text(context.tr('Image preview is not available')),
                      ),
                )
                : const _ImagePlaceholder(),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image_outlined, color: Colors.green, size: 36),
              const SizedBox(height: 8),
              Text(context.tr('No image URL selected')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.trim().isEmpty ? '-' : value.trim())),
        ],
      ),
    );
  }
}
