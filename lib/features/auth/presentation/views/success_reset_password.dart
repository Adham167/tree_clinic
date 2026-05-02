import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';

class SuccessResetPassword extends StatelessWidget {
  const SuccessResetPassword({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 250),
            Center(
              child: Image.asset(
                "assets/images/Screenshot 2025-10-27 172055.png",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                context.tr("Successful"),
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 50),
            CustomButton(name: context.tr("Continue")),
          ],
        ),
      ),
    );
  }
}
