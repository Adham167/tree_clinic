import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/custom_app_bar.dart';
 import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';

class PasswordReset extends StatelessWidget {
  const PasswordReset({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      appBar: CustomAppBar(height: 120),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap:
              true, // Tells the ListView to be only as tall as its children
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text("Password Reset", style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            Text(
              "Your password has been successfully reset. click confirm to set a new password",
              style: TextStyle(color: AppColors.kseconderyColor, fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kNewPasswordView);
                },
                child: CustomButton(name: "Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
