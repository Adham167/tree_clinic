import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
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
              GoRouter.of(context).push(AppRouter.kGetOnBoardingView);
            } else if (state is Authenticated) {
              GoRouter.of(context).push(AppRouter.kHomeView);
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    elevation: 8,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(Assets.imagesLogo1),
                    ),
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
