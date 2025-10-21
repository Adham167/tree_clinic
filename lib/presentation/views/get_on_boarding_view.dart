import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/assets.dart';

class GetOnBoardingView extends StatelessWidget {
  const GetOnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(Assets.imagesImfg1, fit: BoxFit.cover),

          Container(color: Colors.white.withOpacity(0.35)),

          Center(
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
        ],
      ),
    );
  }
}
