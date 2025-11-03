import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
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
            SizedBox(height: 250),
            Center(
              child: Image.asset(
                "assets/images/Screenshot 2025-10-27 172055.png",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text("Successful", style: TextStyle(fontSize: 30)),
            ),
            SizedBox(height: 50),
            CustomButton(name: "Continue"),
          ],
        ),
      ),
    );
  }
}
