import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';

import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';

class SucessSignUp extends StatelessWidget {
  const SucessSignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 250),
            Center(child: Image.asset(Assets.imagesSuccess)),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text("Successful", style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: 50),
            CustomButton(
              name: "Continue",
              ontap:
                  () =>
                      GoRouter.of(context).pushReplacement(AppRouter.kHomeView),
            ),
          ],
        ),
      ),
    );
  }
}
