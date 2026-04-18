import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/app/theme/light_theme.dart';
import 'package:tree_clinic/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tree_clinic/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:tree_clinic/features/prediction/presentation/manager/cubit/prediction_cubit.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_product_cubit/get_product_cubit.dart';
import 'package:tree_clinic/presentation/manager/current_user_cubit/current_user_cubit.dart';

class TreeClinic extends StatelessWidget {
  const TreeClinic({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CurrentUserCubit(usecase: sl<GetCurrentUserUsecase>()),
        ), // توفر مرة واحدة للتطبيق كله
        BlocProvider(create: (_) => CartCubit()), // كارت مشترك
        BlocProvider(create: (_) => GetProductsCubit()),
        BlocProvider(create: (context) => PredictionCubit()),
        // لو هتحتاجه في أماكن متعددة
        // أضف أي Cubit/Bloc آخر تستخدمه في عدة صفحات
      ],
      child: MaterialApp.router(
        theme: LightTheme.theme,
        debugShowCheckedModeBanner: false,
        // useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
