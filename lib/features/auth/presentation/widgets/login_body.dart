import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap:
            true, 
        children: [
          SizedBox(height: 16),
          Text("Email", style: AppStyles.styleRegular16),
          SizedBox(height: 6),
          CustomTextField(hint: "Email"),
          SizedBox(height: 20),
          Text("Password", style: AppStyles.styleRegular16),
          SizedBox(height: 6),
          CustomTextField(hint: "Password"),
          Row(
            children: [
              SizedBox(height: 50),
              Text(
                "Wrong Password",
                style: TextStyle(color: AppColors.kseconderyColor),
              ),
              Spacer(flex: 1),
              GestureDetector(
                onTap:
                    () => GoRouter.of(context).push(AppRouter.kForgotPassword),

                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: AppColors.kmainColor),
                ),
              ),
            ],
          ),
          CustomButton(name: "Continue"),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Center(
              child: Row(
                children: [
                  Spacer(flex: 1),
                  Container(
                    height: 1,
                    width: 150,
                    color: Color.fromARGB(255, 192, 192, 192),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Or",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 192, 192, 192),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: 6),
                  Container(
                    height: 1,
                    width: 150,
                    color: Color.fromARGB(255, 192, 192, 192),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kseconderyColor, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  width: 30,
                  height: 30,
                  image: AssetImage(Assets.imagesAppleIcons),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Login with apple",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kseconderyColor, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  width: 30,
                  height: 30,
                  image: AssetImage(Assets.imagesGoogleIcon),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Login with apple",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
