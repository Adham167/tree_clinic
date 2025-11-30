import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/custom_app_bar.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class NewPasswordView extends StatelessWidget {
  const NewPasswordView({super.key});
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
            Text("Set a New Password", style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            Text(
              "Create a new password. Ensure it differs from previous ones for security",
              style: TextStyle(color: AppColors.kseconderyColor, fontSize: 15),
            ),
            Text("Password", style: AppStyles.styleRegular16),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CustomFormTextField(label: "Password",),
            ),
            Text("Confirm Password", style: AppStyles.styleRegular16),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomFormTextField(label: "Confirm Password"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).push(AppRouter.kSuccessResetPassword);
                },
                child: CustomButton(name: "Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
