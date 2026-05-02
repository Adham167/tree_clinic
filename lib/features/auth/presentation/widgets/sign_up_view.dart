import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/auth_language_button.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signup_usecase.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signup_validation_cubit/signup_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/user_type_drop_down.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  GlobalKey<FormState> globalKey = GlobalKey();
  UserModel userModel = UserModel(
    name: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
    type: "",
  );
  bool obsecureText1 = true;
  bool obsecureText2 = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonCubit, ButtonState>(
      listener: (context, state) {
        if (state is ButtonFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.tr(state.errMessage))));
          log(state.errMessage);
        } else if (state is ButtonSuccess) {
          GoRouter.of(context).go(AppRouter.kMainNavigation);
        }
      },
      child: BlocBuilder<SignupValidationCubit, SignupValidationState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Hero(
                  tag: "onboardHero",
                  child: Image.asset(
                    Assets.imagesSignUp,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                const SafeArea(
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(top: 16, end: 16),
                      child: AuthLanguageButton(onDarkBackground: true),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 240,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF6EA),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: globalKey,
                        child: Column(
                          // Tells the ListView to be only as tall as its children
                          children: [
                            SizedBox(height: 16),
                            Text(
                              context.tr("Create Account"),
                              style: AppStyles.styleBold24.copyWith(
                                color: AppColors.lightPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Text(
                              context.tr("Register now and enjoy the app"),
                              style: AppStyles.styleRegular16,
                            ),

                            const SizedBox(height: 30),

                            CustomFormTextField(
                              label: "Full Name",
                              onChanged: (data) {
                                userModel.name = data;
                              },
                            ),
                            SizedBox(height: 8),

                            CustomFormTextField(
                              label: "E-mail",
                              isEmailField: true,
                              onChanged: (data) {
                                userModel.email = data;
                              },
                            ),
                            SizedBox(height: 8),

                            CustomFormTextField(
                              label: "Phone",
                              onChanged: (data) {
                                userModel.phone = data;
                              },
                            ),
                            SizedBox(height: 8),
                            UserTypeDropDown(
                              onchange: (value) {
                                userModel.type = value!;
                              },
                            ),
                            SizedBox(height: 8),
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
                                  obsecureText1
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              onChanged: (data) {
                                userModel.password = data;
                              },
                            ),
                            SizedBox(height: 8),

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
                                  obsecureText2
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              onChanged: (data) {
                                userModel.confirmPassword = data;
                              },
                            ),
                            if (state is SignupValidationFailure)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Text(
                                  context.tr(state.errMessage),
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CustomReactiveButton(
                                onPressed: () {
                                  if (globalKey.currentState!.validate()) {
                                    if (userModel.password !=
                                        userModel.confirmPassword) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            context.tr(
                                              "Passwords do not match.",
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    BlocProvider.of<ButtonCubit>(
                                      context,
                                    ).excute(
                                      usecase: SignupUsecase(),
                                      params: UserModel(
                                        name: userModel.name,
                                        email: userModel.email,
                                        phone: userModel.phone,
                                        password: userModel.password,
                                        confirmPassword:
                                            userModel.confirmPassword,
                                        type: userModel.type,
                                      ),
                                    );
                                  }
                                },
                                title: context.tr('Register'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(context.tr("Already have an account?")),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: () {
                                    GoRouter.of(
                                      context,
                                    ).pushReplacement(AppRouter.kLoginView);
                                  },
                                  child: Text(
                                    context.tr("Login"),
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
