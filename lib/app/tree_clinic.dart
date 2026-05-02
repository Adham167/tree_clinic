import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/app/theme/light_theme.dart';
import 'package:tree_clinic/core/localization/app_localizations.dart';
import 'package:tree_clinic/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tree_clinic/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:tree_clinic/features/prediction/presentation/manager/cubit/prediction_cubit.dart';
import 'package:tree_clinic/features/profile/presentation/manager/app_locale_cubit.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_product_cubit/get_product_cubit.dart';
import 'package:tree_clinic/presentation/manager/current_user_cubit/current_user_cubit.dart';

class TreeClinic extends StatelessWidget {
  const TreeClinic({
    super.key,
    required this.preferences,
    required this.initialLocale,
  });

  final SharedPreferences preferences;
  final Locale initialLocale;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppLocaleCubit(preferences, initialLocale),
        ),
        BlocProvider(
          create: (_) => CurrentUserCubit(usecase: sl<GetCurrentUserUsecase>()),
        ),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => GetProductsCubit()),
        BlocProvider(create: (_) => PredictionCubit()),
      ],
      child: BlocBuilder<AppLocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            theme: LightTheme.theme,
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
