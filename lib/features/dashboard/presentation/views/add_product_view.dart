// features/dashboard/presentation/views/add_product_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button2.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_product_cubit/add_product_cubit.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final diseaseController = TextEditingController();
    final categoryController = TextEditingController();
    final imageController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // حقول الإدخال
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Product Name")),
            const SizedBox(height: 12),
            TextField(controller: descController, maxLines: 3, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 12),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price")),
            const SizedBox(height: 12),
            TextField(controller: diseaseController, decoration: const InputDecoration(labelText: "Disease (e.g., Rust, Blight)")),
            const SizedBox(height: 12),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: "Category (e.g., Fungicide, Fertilizer)")),
            const SizedBox(height: 12),
            TextField(controller: imageController, decoration: const InputDecoration(labelText: "Image URL")),
            const SizedBox(height: 30),

            BlocConsumer<AddProductCubit, AddProductState>(
              listener: (context, state) {
                if (state is AddProductSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product added successfully!")),
                  );
                  context.pop(); // يرجع للداشبورد
                }
                if (state is AddProductFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                return CustomReactiveButton2(
                  title: "Add Product",
                  color: Colors.green,
                  isLoading: state is AddProductLoading,
                  onPressed: () {
                    final price = double.tryParse(priceController.text);
                    if (price == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid price")),
                      );
                      return;
                    }
                    context.read<AddProductCubit>().addProduct(
                      name: nameController.text,
                      description: descController.text,
                      image: imageController.text,
                      price: price,
                      disease: diseaseController.text,
                      category: categoryController.text,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}