import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/core/widgets/auth_language_button.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signin_validation_cubit/signin_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signup_validation_cubit/signup_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/views/login_view.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/sign_up_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtonCubit()),
        BlocProvider(create: (context) => SignupValidationCubit()),
        BlocProvider(create: (context) => SigninValidationCubit()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 30,
            leading: Container(),
            actions: const [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 12),
                child: Center(child: AuthLanguageButton()),
              ),
            ],
            bottom: TabBar(
              indicatorColor: AppColors.kmainColor,
              labelColor: AppColors.kmainColor,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: AppColors.kseconderyColor,
              tabs: [
                Tab(child: Text(context.tr("Login"))),
                Tab(child: Text(context.tr("Sign Up"))),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: const TabBarView(children: [LoginView(), SignUpView()]),
          ),
        ),
      ),
    );
  }
}
