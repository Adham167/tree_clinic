import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/cart/data/model/cart_item.dart';
import 'package:tree_clinic/features/cart/data/model/delivery_details.dart';
import 'package:tree_clinic/features/cart/presentation/widgets/checkout_delivery_sheet.dart';
import 'package:tree_clinic/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('My Cart')),
        backgroundColor: Colors.green,
      ),
      body: BlocBuilder<CartCubit, List<CartItem>>(
        builder: (context, cart) {
          if (cart.isEmpty) {
            return Center(child: Text(context.tr('Cart is empty')));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading:
                            item.image.trim().isEmpty
                                ? const Icon(Icons.inventory_2_outlined)
                                : Image.network(
                                  item.image,
                                  width: 50,
                                  errorBuilder:
                                      (_, __, ___) =>
                                          const Icon(Icons.inventory_2_outlined),
                                ),
                        title: Text(item.name),
                        subtitle: Text(
                          '${item.price} ${context.tr('EGP')}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                context.read<CartCubit>().decreaseQty(item.id);
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                context.read<CartCubit>().increaseQty(item.id);
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('Total:'),
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${context.read<CartCubit>().totalPrice} ${context.tr('EGP')}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final cubit = context.read<CartCubit>();
                          try {
                            final initialDetails =
                                await cubit.loadDeliveryDetailsDraft();
                            if (!context.mounted) return;
                            final deliveryDetails =
                                await showModalBottomSheet<DeliveryDetails>(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder:
                                      (_) => CheckoutDeliverySheet(
                                        initialDetails: initialDetails,
                                      ),
                                );
                            if (deliveryDetails == null) {
                              return;
                            }
                            await cubit.checkout(
                              deliveryDetails: deliveryDetails,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr(
                                    'Order request sent for merchant approval.',
                                  ),
                                ),
                              ),
                            );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          } catch (error) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text(context.tr('Checkout')),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
