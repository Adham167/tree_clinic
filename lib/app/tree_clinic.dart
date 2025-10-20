import 'package:flutter/material.dart';
import 'package:tree_clinic/app/router/app_router.dart';

class TreeClinic extends StatelessWidget {
  const TreeClinic({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}