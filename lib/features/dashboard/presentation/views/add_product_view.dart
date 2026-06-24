import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/core/catalog/tree_disease_catalog.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button2.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_product_cubit/add_product_cubit.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/media_step.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/product_info_step.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/treatment_step.dart';
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

  final nameEnController = TextEditingController();
  final nameArController = TextEditingController();
  final descEnController = TextEditingController();
  final descArController = TextEditingController();
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
  bool get _isOtherTreeSelected =>
      selectedTree == TreeDiseaseCatalog.otherOption;
  bool get _isOtherDiseaseSelected =>
      selectedDisease == TreeDiseaseCatalog.otherOption;

  String? get _selectedKnownTree {
    if (selectedTree == null || _isOtherTreeSelected) return null;
    return selectedTree;
  }

  List<String> get _treeOptions =>
      [...TreeDiseaseCatalog.treeNames, TreeDiseaseCatalog.otherOption];

  List<String> get _diseaseOptions {
    final knownTree = _selectedKnownTree;
    if (knownTree == null) return const [];
    return [
      ...TreeDiseaseCatalog.diseasesFor(knownTree),
      TreeDiseaseCatalog.otherOption,
    ];
  }

  String get _resolvedTree {
    if (_isOtherTreeSelected) return customTreeController.text.trim();
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

    nameEnController.text = product.nameEn;
    nameArController.text = product.nameAr;
    descEnController.text = product.descriptionEn;
    descArController.text = product.descriptionAr;
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
          TreeDiseaseCatalog.containsDiseaseForTree(
            selectedTree!,
            savedDisease,
          )) {
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
    nameEnController.dispose();
    nameArController.dispose();
    descEnController.dispose();
    descArController.dispose();
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
        final messageKey = isEditing
            ? 'Update {name} as a {category} product?'
            : 'Add {name} as a {category} product?';

        return AlertDialog(
          title: Text(context.tr('Confirm product')),
          content: Text(
            context.tr(
              messageKey,
              params: {
                'name': nameEnController.text.trim().isNotEmpty
                    ? nameEnController.text.trim()
                    : nameArController.text.trim(),
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
          nameEn: nameEnController.text.trim(),
          nameAr: nameArController.text.trim(),
          descriptionEn: descEnController.text.trim(),
          descriptionAr: descArController.text.trim(),
          image: imageController.text.trim(),
          price: price,
          tree: _resolvedTree,
          disease: _resolvedDisease,
          category: selectedCategory,
        ),
      );
    } else {
      context.read<AddProductCubit>().addProduct(
        nameEn: nameEnController.text.trim(),
        nameAr: nameArController.text.trim(),
        descriptionEn: descEnController.text.trim(),
        descriptionAr: descArController.text.trim(),
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
              SnackBar(
                content: Text(_localizeStateMessage(context, state.message)),
              ),
            );
            context.pop();
          }
          if (state is AddProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(_localizeStateMessage(context, state.errMessage)),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AddProductLoading;

          return Stepper(
            currentStep: currentStep,
            onStepTapped: isLoading
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
                state:
                    currentStep > 0 ? StepState.complete : StepState.indexed,
                content: ProductInfoStep(
                  formKey: _productFormKey,
                  nameEnController: nameEnController,
                  nameArController: nameArController,
                  descEnController: descEnController,
                  descArController: descArController,
                ),
              ),
              Step(
                title: Text(context.tr('Treatment')),
                isActive: currentStep >= 1,
                state:
                    currentStep > 1 ? StepState.complete : StepState.indexed,
                content: TreatmentStep(
                  formKey: _treatmentFormKey,
                  priceController: priceController,
                  customTreeController: customTreeController,
                  customDiseaseController: customDiseaseController,
                  categories: categories,
                  selectedCategory: selectedCategory,
                  selectedTree: selectedTree,
                  selectedDisease: selectedDisease,
                  treeOptions: _treeOptions,
                  diseaseOptions: _diseaseOptions,
                  isOtherTreeSelected: _isOtherTreeSelected,
                  isOtherDiseaseSelected: _isOtherDiseaseSelected,
                  selectedKnownTree: _selectedKnownTree,
                  isLoading: isLoading,
                  onCategoryChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCategory = value);
                    }
                  },
                  onTreeChanged: isLoading ? (_) {} : _onTreeChanged,
                  onDiseaseChanged: (value) {
                    setState(() {
                      selectedDisease = value;
                      if (value != TreeDiseaseCatalog.otherOption) {
                        customDiseaseController.clear();
                      }
                    });
                  },
                ),
              ),
              Step(
                title: Text(context.tr('Media')),
                isActive: currentStep >= 2,
                content: MediaStep(
                  formKey: _mediaFormKey,
                  imageController: imageController,
                  onImageChanged: () => setState(() {}),
                  displayName: nameEnController.text.trim().isNotEmpty
                      ? nameEnController.text.trim()
                      : nameArController.text.trim(),
                  displayCategory: _displayValue(context, selectedCategory),
                  displayTree: _displayValue(context, _resolvedTree),
                  displayDisease: _displayValue(context, _resolvedDisease),
                  priceText: priceController.text.trim(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}