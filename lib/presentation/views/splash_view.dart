import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/presentation/manager/get_started_cubit/get_started_cubit.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetStartedCubit()..getStarted(),
      child: Scaffold(
        backgroundColor: AppColors.kmainColor,
        body: BlocListener<GetStartedCubit, GetStartedState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              GoRouter.of(context).go(AppRouter.kGetOnBoardingView);
            } else if (state is Authenticated) {
              GoRouter.of(context).go(AppRouter.kMainNavigation);
            }
          },
          child: TweenAnimationBuilder(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(Assets.imagesLogo, height: 120, width: 120),
                  SizedBox(height: 8),
                  Text(
                    'Enjoy your life with plants',
                    style: AppStyles.styleBold36,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
