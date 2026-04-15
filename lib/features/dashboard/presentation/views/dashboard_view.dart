import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/get_shop_cubit/get_shop_cubit.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/dashboard_card.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/dashboard_header.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => context.read<GetShopCubit>().getMyShop());

    return BlocListener<GetShopCubit, GetShopState>(
      listener: (context, state) {
        if (state is GetShopSuccess) {
          if (state.shopEntity != null) {
            // لديه متجر → اذهب إلى MyShopView
            GoRouter.of(
              context,
            ).push(AppRouter.kMyShopView, extra: state.shopEntity);
          } else {
            // لا يوجد متجر → اذهب إلى CreateShopView
            GoRouter.of(context).push(AppRouter.kCreateShopView);
          }
        } else if (state is GetShopFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text("Merchant Dashboard"),
          backgroundColor: Colors.green,
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const DashboardHeader(),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    DashboardCard(
                      onTap: () {
                        context.read<GetShopCubit>().getMyShop();
                      },
                      title: "Add Shop",
                      icon: Icons.store,
                      color: Colors.green,
                    ),
                    DashboardCard(
                      title: "Add Category",
                      icon: Icons.category,
                      color: Colors.orange,
                    ),
                    DashboardCard(
                      title: "Add Product",
                      icon: Icons.add_box,
                      color: Colors.blue,
                    ),
                    DashboardCard(
                      title: "Orders",
                      icon: Icons.shopping_cart,
                      color: Colors.purple,
                    ),
                    DashboardCard(
                      title: "My Products",
                      icon: Icons.inventory,
                      color: Colors.teal,
                    ),
                    DashboardCard(
                      title: "Statistics",
                      icon: Icons.bar_chart,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
