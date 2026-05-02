import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/get_shop_cubit/get_shop_cubit.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/dashboard_card.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/widgets/dashboard_header.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetShopCubit>().getMyShop();
    });
  }

  Future<void> _openShopFlow(GetShopState state) async {
    if (state is GetShopSuccess) {
      final result = await context.push(
        AppRouter.kMyShopView,
        extra: state.shopEntity,
      );
      if (!mounted) return;
      context.read<GetShopCubit>().getMyShop();
      if (result is String && result.trim().isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr(result))));
      }
      return;
    }

    await context.push(AppRouter.kCreateShopView);
    if (!mounted) return;
    context.read<GetShopCubit>().getMyShop();
  }

  Future<void> _openProductFlow(GetShopState state) async {
    if (state is GetShopSuccess) {
      await context.push(AppRouter.kaddProductView);
      if (!mounted) return;
      context.read<GetShopCubit>().getMyShop();
      return;
    }

    if (state is GetShopLoading) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('Create your shop first, then add products.')),
      ),
    );
    await context.push(AppRouter.kCreateShopView);
    if (!mounted) return;
    context.read<GetShopCubit>().getMyShop();
  }

  void _openProductsManager(GetShopState state) {
    if (state is GetShopSuccess) {
      context.push(AppRouter.kManageProductsView, extra: state.shopEntity);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('Create your shop first.'))),
    );
  }

  void _openSalesAnalytics(GetShopState state) {
    if (state is GetShopSuccess) {
      context.push(AppRouter.kSalesAnalyticsView, extra: state.shopEntity);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('Create your shop first.'))),
    );
  }

  void _openOrderApprovals(GetShopState state) {
    if (state is GetShopSuccess) {
      context.push(
        AppRouter.kMerchantOrderRequestsView,
        extra: state.shopEntity,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('Create your shop first.'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(context.tr('Merchant Dashboard')),
        backgroundColor: Colors.green,
        leading: const BackButton(),
      ),
      body: BlocConsumer<GetShopCubit, GetShopState>(
        listener: (context, state) {
          if (state is GetShopFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<GetShopCubit>().getMyShop(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const DashboardHeader(),
                const SizedBox(height: 20),
                _ShopStatusBanner(state: state),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.15,
                  children: [
                    DashboardCard(
                      onTap: () => _openShopFlow(state),
                      title: state is GetShopSuccess ? 'My Shop' : 'Add Shop',
                      icon: Icons.store,
                      color: Colors.green,
                    ),
                    DashboardCard(
                      title: 'Add Product',
                      icon: Icons.add_box,
                      color: Colors.blue,
                      onTap: () => _openProductFlow(state),
                    ),
                    DashboardCard(
                      title: 'Products',
                      icon: Icons.inventory_2,
                      color: Colors.teal,
                      onTap: () => _openProductsManager(state),
                    ),
                    DashboardCard(
                      title: 'Sales',
                      icon: Icons.bar_chart,
                      color: Colors.deepPurple,
                      onTap: () => _openSalesAnalytics(state),
                    ),
                    _OrderApprovalsCard(
                      state: state,
                      onTap: () => _openOrderApprovals(state),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderApprovalsCard extends StatelessWidget {
  const _OrderApprovalsCard({required this.state, required this.onTap});

  final GetShopState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (state is! GetShopSuccess) {
      return DashboardCard(
        title: 'Order Approvals',
        icon: Icons.fact_check_outlined,
        color: Colors.orange,
        onTap: onTap,
      );
    }

    final shop = (state as GetShopSuccess).shopEntity;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance
              .collection('merchant_order_requests')
              .where('shopId', isEqualTo: shop.id)
              .snapshots(),
      builder: (context, snapshot) {
        final pendingCount =
            snapshot.data?.docs
                .where(
                  (doc) =>
                      (doc.data()['status']?.toString() ?? 'pending') ==
                      'pending',
                )
                .length ??
            0;

        return DashboardCard(
          title: 'Order Approvals',
          icon: Icons.fact_check_outlined,
          color: Colors.orange,
          badgeCount: pendingCount,
          onTap: onTap,
        );
      },
    );
  }
}

class _ShopStatusBanner extends StatelessWidget {
  const _ShopStatusBanner({required this.state});

  final GetShopState state;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    final String title;
    final String message;

    if (state is GetShopLoading) {
      color = Colors.blueGrey;
      icon = Icons.sync;
      title = context.tr('Checking shop');
      message = context.tr('Loading your merchant shop status...');
    } else if (state is GetShopSuccess) {
      final shop = (state as GetShopSuccess).shopEntity;
      color = Colors.green;
      icon = Icons.verified;
      title = shop.name;
      message = context.tr('Products you add will be linked to this shop.');
    } else if (state is GetShopEmpty) {
      color = Colors.orange;
      icon = Icons.store_mall_directory_outlined;
      title = context.tr('No shop yet');
      message = context.tr('Create a shop before adding products.');
    } else if (state is GetShopFailure) {
      color = Colors.red;
      icon = Icons.error_outline;
      title = context.tr('Shop check failed');
      message = (state as GetShopFailure).errMessage;
    } else {
      color = Colors.blueGrey;
      icon = Icons.info_outline;
      title = context.tr('Merchant tools');
      message = context.tr('Pull down to refresh your shop status.');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
