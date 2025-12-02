import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/app/theme/light_theme.dart';
import 'package:tree_clinic/features/prediction/presentation/manager/cubit/prediction_cubit.dart';

class TreeClinic extends StatelessWidget {
  const TreeClinic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PredictionCubit(),
      child: MaterialApp.router(
        theme: LightTheme.theme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
