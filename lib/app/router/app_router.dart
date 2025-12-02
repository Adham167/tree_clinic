import 'package:go_router/go_router.dart';
import 'package:tree_clinic/features/auth/presentation/views/forget_password.dart';
import 'package:tree_clinic/features/auth/presentation/views/new_password.dart';
import 'package:tree_clinic/features/auth/presentation/views/register_view.dart';
import 'package:tree_clinic/features/auth/presentation/views/success_reset_password.dart';
import 'package:tree_clinic/features/auth/presentation/views/sucess_sign_up.dart';
import 'package:tree_clinic/lib/main_navigation.dart';
import 'package:tree_clinic/presentation/views/home_view.dart';
import 'package:tree_clinic/presentation/views/on_boarding_view.dart';
import 'package:tree_clinic/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const kGetOnBoardingView = '/GetOnBoardingView';
  static const kHomeView = '/HomeView';
  static const kOnBoardingView = '/OnBoardingView';
  static const kRegisterView = '/RegisterView';
  static const kForgotPassword = '/ForgotPassword';
  static const kNewPasswordView = '/NewPasswordView';
  static const kSuccessResetPassword = '/SuccessResetPassword';
  static const kSucessSignUp = '/SucessSignUp';
  static const kMainNavigation = '/MainNavigation';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),

      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(
        path: kMainNavigation,
        builder:
            (context, state) => const MainNavigation(),
      ),
      GoRoute(
        path: kOnBoardingView,
        builder: (context, state) => OnBoardingView(),
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
