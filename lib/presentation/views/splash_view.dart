import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
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
        backgroundColor: const Color.fromARGB(255, 171, 244, 174),
        body: BlocListener<GetStartedCubit, GetStartedState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              GoRouter.of(context).push(AppRouter.kOnBoardingView);
            } else if (state is Authenticated) {
              GoRouter.of(context).push(AppRouter.kHomeView);
            }
          },
          child: Stack(
            fit: StackFit.expand,

            children: [
              Image.asset("assets/images/imfg_1.jpg", fit: BoxFit.cover),
              Container(color: Colors.white.withOpacity(0.35)),

              TweenAnimationBuilder(
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
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 300,
                        child: Text(
                          'Enjoy your life with plants',
                          style: AppStyles.styleBold36,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 32),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(
                            context,
                          ).pushReplacement(AppRouter.kOnBoardingView);
                        },
                        child: SizedBox(
                          height: 80,
                          child: Image.asset(Assets.imagesArrowRight2),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
