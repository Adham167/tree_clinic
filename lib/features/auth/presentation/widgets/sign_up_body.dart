import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signup_usecase.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signup_validation_cubit/signup_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class SignUpBody extends StatelessWidget {
  SignUpBody({super.key});

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errMessage)));
            log(state.errMessage);
          } else if (state is ButtonSuccess) {
            GoRouter.of(context).push(AppRouter.kHomeView);
          }
        },
        child: BlocBuilder<SignupValidationCubit, SignupValidationState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap:
                  true, // Tells the ListView to be only as tall as its children
              children: [
                SizedBox(height: 16),
                Text("Full Name", style: AppStyles.styleRegular16),
                SizedBox(height: 6),
                CustomTextField(hint: "Full Name", controller: _fullName),
                SizedBox(height: 6),
                Text("E-mail", style: AppStyles.styleRegular16),
                SizedBox(height: 6),
                CustomTextField(hint: "E-mail", controller: _email),
                SizedBox(height: 6),
                Text("Phone", style: AppStyles.styleRegular16),
                SizedBox(height: 6),
                CustomTextField(hint: "Phone", controller: _phone),
                SizedBox(height: 6),
                Text("Password", style: AppStyles.styleRegular16),
                SizedBox(height: 6),
                CustomTextField(hint: "Password", controller: _password),
                SizedBox(height: 6),

                Text("Confirm Password", style: AppStyles.styleRegular16),

                CustomTextField(
                  hint: "Confirm Password",
                  controller: _confirmpassword,
                ),
                if (state is SignupValidationFailure)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      state.errMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CustomReactiveButton(
                    onPressed: () {
                      BlocProvider.of<SignupValidationCubit>(context).validate(
                        fullName: _fullName.text.trim(),
                        email: _email.text.trim(),
                        phone: _phone.text.trim(),
                        password: _password.text.trim(),
                        confirmpassword: _confirmpassword.text.trim(),
                      );
                      final validationState =
                          BlocProvider.of<SignupValidationCubit>(context).state;

                      if (validationState is SignupValidationIsValid) {
                        BlocProvider.of<ButtonCubit>(context).excute(
                          usecase: SignupUsecase(),
                          params: UserModel(
                            name: _fullName.text.trim(),
                            email: _email.text.trim(),
                            phone: _phone.text.trim(),
                            password: _password.text.trim(),
                            ConfirmPassword: _confirmpassword.text.trim(),
                          ),
                        );
                      }
                    },
                    title: 'Register',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
