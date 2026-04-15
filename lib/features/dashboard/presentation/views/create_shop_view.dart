import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button2.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_shop_cubit/add_shop_cubit.dart';

class CreateShopView extends StatefulWidget {
  const CreateShopView({super.key});

  @override
  State<CreateShopView> createState() => _CreateShopViewState();
}

class _CreateShopViewState extends State<CreateShopView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
        title: const Text("Create Shop"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
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
                child: const Column(
                  children: [
                    Icon(Icons.store, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      "Create Your Shop",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Shop Name",
                  prefixIcon: const Icon(Icons.store),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: BlocConsumer<AddShopCubit, AddShopState>(
                  listener: (context, state) {
                    if (state is AddShopSuccess) {
                      GoRouter.of(context).pop();
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
                        title: "Create Shop",
                        color: Colors.green,
                        isLoading: state is AddShopLoading,
                        onPressed: () {
                          final shop = ShopEntity(
                            id: "",
                            ownerId: "",
                            name: nameController.text,
                            description: descController.text,
                            image: '',
                            createdAt: DateTime.now(),
                            address: addressController.text,
                          );
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
    );
  }
}
