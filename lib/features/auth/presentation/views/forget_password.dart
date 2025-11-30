import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/custom_app_bar.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});
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
            Text("Forget Password", style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            Text(
              "Please enter you email to reset the passeord",
              style: TextStyle(color: AppColors.kseconderyColor, fontSize: 15),
            ),
            Text("Your Email", style: AppStyles.styleRegular16),

            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CustomFormTextField(label: "Your Email"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => OTPScreen()),
                  // );
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
