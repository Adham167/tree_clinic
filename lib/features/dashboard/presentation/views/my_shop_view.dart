import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_shop_cubit/add_shop_cubit.dart';

class MyShopView extends StatefulWidget {
  const MyShopView({super.key, required this.shop});

  final ShopEntity shop;

  @override
  State<MyShopView> createState() => _MyShopViewState();
}

class _MyShopViewState extends State<MyShopView> {
  late ShopEntity shop;

  @override
  void initState() {
    super.initState();
    shop = widget.shop;
  }

  Future<void> _editShop() async {
    final result = await context.push(AppRouter.kCreateShopView, extra: shop);
    if (!mounted) return;

    if (result is ShopEntity) {
      setState(() => shop = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('Shop updated successfully.'))),
      );
    }
  }

  Future<void> _resetShop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(dialogContext.tr('Reset Shop')),
            content: Text(
              dialogContext.tr(
                'Delete this shop and all products inside it? This action cannot be undone.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(dialogContext.tr('Cancel')),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                icon: const Icon(Icons.delete_forever),
                label: Text(dialogContext.tr('Delete Shop')),
              ),
            ],
          ),
    );

    if (confirmed != true || !mounted) return;
    context.read<AddShopCubit>().deleteShop(shop.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddShopCubit, AddShopState>(
      listener: (context, state) {
        if (state is AddShopDeleteSuccess) {
          context.pop(state.message);
        } else if (state is AddShopFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr(state.errMessage)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddShopLoading;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(context.tr('My Shop')),
            centerTitle: true,
            backgroundColor: Colors.green,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.store,
                            color: Colors.green,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              shop.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        context.tr('Description'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        shop.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              shop.address,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading ? null : _editShop,
                    icon: const Icon(Icons.edit),
                    label: Text(
                      context.tr('Edit Shop'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: isLoading ? null : _resetShop,
                    icon:
                        isLoading
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.delete_forever),
                    label: Text(
                      context.tr('Reset Shop'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
