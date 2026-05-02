import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/constants/assets.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/auth_language_button.dart';
import 'package:tree_clinic/core/widgets/custom_reactive_button.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';
import 'package:tree_clinic/features/auth/domain/usecases/google_signin_usecase.dart';
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
          ).showSnackBar(SnackBar(content: Text(context.tr(state.errMessage))));
        } else if (state is ButtonSuccess) {
          GoRouter.of(context).go(AppRouter.kMainNavigation);
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
                          children: [
                            const SizedBox(height: 20),

                            Text(
                              context.tr("Welcome Back"),
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
                                  context.tr(state.errMessage),
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
                                    context.tr("Forgot Password?"),
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
                              title: context.tr("Continue"),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    context.tr("or"),
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 18),
                            CustomReactiveButton(
                              color: Colors.white,
                              onPressed: () {
                                BlocProvider.of<ButtonCubit>(
                                  context,
                                ).excute(usecase: GoogleSigninUsecase());
                              },
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Assets.imagesGoogleIcon,
                                    width: 22,
                                    height: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.tr("Continue with Google"),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
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
