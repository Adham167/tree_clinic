import 'package:flutter/widgets.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_button.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap:
            true, // Tells the ListView to be only as tall as its children
        children: [
          SizedBox(height: 16),
          Text("Full Name", style: AppStyles.styleRegular16),
          SizedBox(height: 6),
          CustomTextField(hint: "Full Name"),
          SizedBox(height: 6),
          Text("E-mail", style: AppStyles.styleRegular16),
          SizedBox(height: 6),
          CustomTextField(hint: "E-mail"),
          SizedBox(height: 6),
          Text("Phone", style: AppStyles.styleRegular16),
          SizedBox(height: 6),
          CustomTextField(hint: "Phone"),
          SizedBox(height: 6),
          Text("Password", style: AppStyles.styleRegular16),
          SizedBox(height: 6),
          CustomTextField(hint: "Password"),
          SizedBox(height: 6),

          Text("Confirm Password", style: AppStyles.styleRegular16),

          CustomTextField(hint: "Confirm Password"),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, SucessSignUp().id);
              },
              child: CustomButton(name: "Register"),
            ),
          ),
        ],
      ),
    );
  }
}
