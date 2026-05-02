import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button2.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_shop_cubit/add_shop_cubit.dart';

class CreateShopView extends StatefulWidget {
  const CreateShopView({super.key, this.initialShop});

  final ShopEntity? initialShop;

  @override
  State<CreateShopView> createState() => _CreateShopViewState();
}

class _CreateShopViewState extends State<CreateShopView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  ShopEntity? _submittedShop;

  bool get isEditing => widget.initialShop != null;

  @override
  void initState() {
    super.initState();
    final shop = widget.initialShop;
    if (shop != null) {
      nameController.text = shop.name;
      descController.text = shop.description;
      addressController.text = shop.address;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(context.tr(isEditing ? 'Edit Shop' : 'Create Shop')),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.greenAccent],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.store, size: 60, color: Colors.white),
                      const SizedBox(height: 10),
                      Text(
                        context.tr(
                          isEditing ? 'Update Your Shop' : 'Create Your Shop',
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: context.tr('Shop Name'),
                    prefixIcon: const Icon(Icons.store),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr('Shop name is required');
                    }
                    if (value.trim().length < 3) {
                      return context.tr(
                        'Shop name must be at least 3 characters',
                      );
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: context.tr('Description'),
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
                const SizedBox(height: 15),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: context.tr('Address'),
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return context.tr('Address is required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: BlocConsumer<AddShopCubit, AddShopState>(
                    listener: (context, state) {
                      if (state is AddShopSuccess) {
                        GoRouter.of(context).pop(_submittedShop);
                      }

                      if (state is AddShopFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomReactiveButton2(
                          title: context.tr(
                            isEditing ? 'Save Changes' : 'Create Shop',
                          ),
                          color: Colors.green,
                          isLoading: state is AddShopLoading,
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            final shop = ShopEntity(
                              id: widget.initialShop?.id ?? '',
                              ownerId: widget.initialShop?.ownerId ?? '',
                              name: nameController.text.trim(),
                              description: descController.text.trim(),
                              image: widget.initialShop?.image ?? '',
                              createdAt:
                                  widget.initialShop?.createdAt ??
                                  DateTime.now(),
                              address: addressController.text.trim(),
                            );
                            _submittedShop = shop;
                            context.read<AddShopCubit>().addShop(shop);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
