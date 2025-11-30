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

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final TextEditingController _fullName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _phone = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _confirmpassword = TextEditingController();

  GlobalKey<FormState> globalKey = GlobalKey();
  UserModel userModel = UserModel(
    name: "",
    email: "",
    phone: "",
    password: "",
    ConfirmPassword: "",
  );
  bool obsecureText1 = true;
  bool obsecureText2 = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocListener<ButtonCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("state.errMessage")));
            log(state.errMessage);
          } else if (state is ButtonSuccess) {
            GoRouter.of(context).push(AppRouter.kSucessSignUp);
          }
        },
        child: BlocBuilder<SignupValidationCubit, SignupValidationState>(
          builder: (context, state) {
            return Form(
              key: globalKey,
              child: ListView(
                shrinkWrap:
                    true, // Tells the ListView to be only as tall as its children
                children: [
                  SizedBox(height: 16),
                  Text("Full Name", style: AppStyles.styleRegular16),
                  SizedBox(height: 6),
                  CustomFormTextField(
                    label: "Full Name",
                    onChanged: (data) {
                      userModel.name = data;
                    },
                  ),
                  SizedBox(height: 6),
                  Text("E-mail", style: AppStyles.styleRegular16),
                  SizedBox(height: 6),
                  CustomFormTextField(
                    label: "E-mail",
                    isEmailField: true,
                    onChanged: (data) {
                      userModel.email = data;
                    },
                  ),
                  SizedBox(height: 6),
                  Text("Phone", style: AppStyles.styleRegular16),
                  SizedBox(height: 6),
                  CustomFormTextField(
                    label: "Phone",
                    onChanged: (data) {
                      userModel.phone = data;
                    },
                  ),
                  SizedBox(height: 6),
                  Text("Password", style: AppStyles.styleRegular16),
                  SizedBox(height: 6),
                  CustomFormTextField(
                    label: "Password",
                    obscureText: obsecureText1,
                    iconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText1 = !obsecureText1;
                        });
                      },
                      icon: Icon(
                        obsecureText1 ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    onChanged: (data) {
                      userModel.password = data;
                    },
                  ),
                  SizedBox(height: 6),

                  Text("Confirm Password", style: AppStyles.styleRegular16),

                  CustomFormTextField(
                    label: "Confirm Password",
                    obscureText: obsecureText2,
                    iconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText2 = !obsecureText2;
                        });
                      },
                      icon: Icon(
                        obsecureText2 ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    onChanged: (data) {
                      userModel.ConfirmPassword = data;
                    },
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
                        if (globalKey.currentState!.validate()) {
                          BlocProvider.of<ButtonCubit>(context).excute(
                            usecase: SignupUsecase(),
                            params: UserModel(
                              name: userModel.name,
                              email: userModel.email,
                              phone: userModel.phone,
                              password: userModel.password,
                              ConfirmPassword: userModel.ConfirmPassword,
                            ),
                          );
                        }
                      },
                      title: 'Register',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
