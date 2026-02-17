import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signin_usecase.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signin_validation_cubit/signin_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          GoRouter.of(context).pushReplacement(AppRouter.kMainNavigation);
        }
      },
      child: BlocBuilder<SigninValidationCubit, SigninValidationState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Hero(
                  tag: "onboardHero",
                  child: Image.asset(
                    Assets.imagesLogin,
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
                          children: [
                            const SizedBox(height: 20),

                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),

                            const SizedBox(height: 30),
                            CustomFormTextField(
                              label: "Email",
                              isEmailField: true,
                              onChanged: (data) {
                                email = data;
                              },
                            ),
                            SizedBox(height: 16),
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
                                  obsecureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                              onChanged: (data) {
                                password = data;
                              },
                            ),
                            if (state is SigninValidationFailure)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
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
                                  style: TextStyle(
                                    color: AppColors.kseconderyColor,
                                  ),
                                ),
                                Spacer(flex: 1),
                                GestureDetector(
                                  onTap:
                                      () => GoRouter.of(
                                        context,
                                      ).push(AppRouter.kForgotPassword),

                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: AppColors.kmainColor,
                                    ),
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
