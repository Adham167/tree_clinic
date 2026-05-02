import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/presentation/manager/current_user_cubit/current_user_cubit.dart';

class MerchantPendingOrdersListener extends StatefulWidget {
  const MerchantPendingOrdersListener({super.key});

  @override
  State<MerchantPendingOrdersListener> createState() =>
      _MerchantPendingOrdersListenerState();
}

class _MerchantPendingOrdersListenerState
    extends State<MerchantPendingOrdersListener> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  String? _merchantId;
  int? _lastPendingCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _handleState(context.read<CurrentUserCubit>().state);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleState(CurrentUserState state) {
    if (state is CurrentUserSuccess && state.userModel.type == 'Merchant') {
      final merchantId = FirebaseAuth.instance.currentUser?.uid;
      if (merchantId == null || merchantId == _merchantId) {
        return;
      }
      _subscription?.cancel();
      _merchantId = merchantId;
      _lastPendingCount = null;
      _subscription = FirebaseFirestore.instance
          .collection('merchant_order_requests')
          .where('merchantId', isEqualTo: merchantId)
          .snapshots()
          .listen(_handleRequestsSnapshot);
      return;
    }

    _subscription?.cancel();
    _subscription = null;
    _merchantId = null;
    _lastPendingCount = null;
  }

  void _handleRequestsSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final pendingCount =
        snapshot.docs
            .where(
              (doc) =>
                  (doc.data()['status']?.toString() ?? 'pending') == 'pending',
            )
            .length;

    final previousCount = _lastPendingCount;
    _lastPendingCount = pendingCount;

    if (!mounted || previousCount == null || pendingCount <= previousCount) {
      return;
    }

    final addedCount = pendingCount - previousCount;
    final message =
        addedCount == 1
            ? context.tr('New order approval request received.')
            : context.tr(
              '{count} new order approval requests received.',
              params: {'count': addedCount.toString()},
            );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: context.tr('Open Dashboard'),
            onPressed: () {
              GoRouter.of(context).push(AppRouter.kDashboardView);
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentUserCubit, CurrentUserState>(
      listener: (context, state) {
        _handleState(state);
      },
      child: const SizedBox.shrink(),
    );
  }
}
