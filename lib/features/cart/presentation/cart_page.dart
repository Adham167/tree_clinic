import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/features/cart/data/model/cart_item.dart';
import 'package:tree_clinic/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Cart"),
          backgroundColor: Colors.green,  
        ),

        body: BlocBuilder<CartCubit, List<CartItem>>(
          builder: (context, cart) {
            if (cart.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            return Column(
              children: [
                /// ITEMS LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(item.image),
                          title: Text(item.name),
                          subtitle: Text("${item.price} EGP"),

                          /// Quantity Controls
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  context.read<CartCubit>().decreaseQty(
                                    item.id,
                                  );
                                },
                              ),

                              Text("${item.quantity}"),

                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  context.read<CartCubit>().increaseQty(
                                    item.id,
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context.read<CartCubit>().removeItem(item.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<CartCubit, List<CartItem>>(
                        builder: (context, cart) {
                          final total = context.read<CartCubit>().totalPrice;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                "$total EGP",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
