import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/dashboard_card.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/dashboard_header.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      GoRouter.of(context).push(AppRouter.kCreateShopView);
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
    );
  }
}
