import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signin_validation_cubit/signin_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/manager/signup_validation_cubit/signup_validation_cubit.dart';
import 'package:tree_clinic/features/auth/presentation/views/auth_choice_view.dart';
import 'package:tree_clinic/features/auth/presentation/views/forget_password.dart';
import 'package:tree_clinic/features/auth/presentation/views/new_password.dart';
import 'package:tree_clinic/features/auth/presentation/views/register_view.dart';
import 'package:tree_clinic/features/auth/presentation/views/success_reset_password.dart';
import 'package:tree_clinic/features/auth/presentation/views/sucess_sign_up.dart';
import 'package:tree_clinic/features/auth/presentation/views/login_view.dart';
import 'package:tree_clinic/features/auth/presentation/widgets/sign_up_view.dart';
import 'package:tree_clinic/presentation/main_navigation.dart';
import 'package:tree_clinic/presentation/views/home_view.dart';
import 'package:tree_clinic/presentation/views/on_boarding_view.dart';

abstract class AppRouter {
  static const kGetOnBoardingView = '/GetOnBoardingView';
  static const kHomeView = '/HomeView';
  static const kAuthCoice = '/AuthCoice';
  static const kRegisterView = '/RegisterView';
  static const kLoginView = '/LoginView';
  static const kSignUpView = '/SignUpView';
  static const kForgotPassword = '/ForgotPassword';
  static const kNewPasswordView = '/NewPasswordView';
  static const kSuccessResetPassword = '/SuccessResetPassword';
  static const kSucessSignUp = '/SucessSignUp';
  static const kMainNavigation = '/MainNavigation';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const OnBoardingView()),
      GoRoute(
        path: kLoginView,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => ButtonCubit()),
                BlocProvider(create: (context) => SignupValidationCubit()),
                BlocProvider(create: (context) => SigninValidationCubit()),
              ],
              child: const LoginView(),
            ),
      ),
      GoRoute(
        path: kSignUpView,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => ButtonCubit()),
                BlocProvider(create: (context) => SignupValidationCubit()),
                BlocProvider(create: (context) => SigninValidationCubit()),
              ],
              child: const SignUpView(),
            ),
      ),

      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(
        path: kMainNavigation,
        builder: (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: kAuthCoice,
        builder: (context, state) => AuthChoiceScreen(),
      ),
      GoRoute(path: kRegisterView, builder: (context, state) => RegisterView()),
      GoRoute(
        path: kForgotPassword,
        builder: (context, state) => ForgotPassword(),
      ),
      GoRoute(
        path: kNewPasswordView,
        builder: (context, state) => NewPasswordView(),
      ),
      GoRoute(
        path: kSuccessResetPassword,
        builder: (context, state) => SuccessResetPassword(),
      ),
      GoRoute(path: kSucessSignUp, builder: (context, state) => SucessSignUp()),
    ],
  );
}
