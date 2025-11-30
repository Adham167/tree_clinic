import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signin_usecase.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signin_validation_cubit/signin_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  GlobalKey<FormState> globalKey = GlobalKey();
  String? email;
  String? password;
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        } else if (state is ButtonSuccess) {
          GoRouter.of(context).push(AppRouter.kHomeView);
        }
      },
      child: BlocBuilder<SigninValidationCubit, SigninValidationState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: globalKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 100),
                  Text("Email", style: AppStyles.styleRegular16),
                  SizedBox(height: 6),
                  CustomFormTextField(
                    label: "Email",
                    isEmailField: true,
                    onChanged: (data) {
                      email = data;
                    },
                  ),
                  SizedBox(height: 20),
                  Text("Password", style: AppStyles.styleRegular16),
                  SizedBox(height: 6),
                  CustomFormTextField(
                    label: "Password",
                    obscureText: obsecureText,
                    iconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText = !obsecureText;
                        });
                      },
                      icon: Icon(
                        obsecureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                    onChanged: (data) {
                      password = data;
                    },
                  ),
                  if (state is SigninValidationFailure)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        state.errMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Row(
                    children: [
                      SizedBox(height: 50),
                      Text(
                        " ",
                        style: TextStyle(color: AppColors.kseconderyColor),
                      ),
                      Spacer(flex: 1),
                      GestureDetector(
                        onTap:
                            () => GoRouter.of(
                              context,
                            ).push(AppRouter.kForgotPassword),

                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: AppColors.kmainColor),
                        ),
                      ),
                    ],
                  ),

                  CustomReactiveButton(
                    onPressed: () {
                      if (globalKey.currentState!.validate()) {
                        BlocProvider.of<ButtonCubit>(context).excute(
                          usecase: SigninUsecase(),
                          params: UserSigninModel(
                            email: email!,
                            password: password!,
                          ),
                        );
                      }
                    },
                    title: "Continue",
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 40),
                  //   child: Center(
                  //     child: Row(
                  //       children: [
                  //         Spacer(flex: 1),
                  //         Container(
                  //           height: 1,
                  //           width: 150,
                  //           color: Color.fromARGB(255, 192, 192, 192),
                  //         ),
                  //         SizedBox(width: 6),
                  //         Text(
                  //           "Or",
                  //           style: TextStyle(
                  //             color: const Color.fromARGB(255, 192, 192, 192),
                  //             fontSize: 24,
                  //           ),
                  //         ),
                  //         SizedBox(width: 6),
                  //         Container(
                  //           height: 1,
                  //           width: 150,
                  //           color: Color.fromARGB(255, 192, 192, 192),
                  //         ),
                  //         Spacer(flex: 1),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 30),
                  // Container(
                  //   height: 50,
                  //   width: 250,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //       color: AppColors.kseconderyColor,
                  //       width: 2,
                  //     ),
                  //     borderRadius: BorderRadius.circular(6),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Image(
                  //         width: 30,
                  //         height: 30,
                  //         image: AssetImage(Assets.imagesAppleIcons),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 10),
                  //         child: Text(
                  //           "Login with apple",
                  //           style: TextStyle(fontSize: 20),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 30),
                  // GestureDetector(
                  //   child: Container(
                  //     height: 50,
                  //     width: 250,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: AppColors.kseconderyColor,
                  //         width: 2,
                  //       ),
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image(
                  //           width: 30,
                  //           height: 30,
                  //           image: AssetImage(Assets.imagesGoogleIcon),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(left: 10),
                  //           child: Text(
                  //             "Login with apple",
                  //             style: TextStyle(fontSize: 20),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
