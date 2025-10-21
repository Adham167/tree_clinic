import 'package:go_router/go_router.dart';
import 'package:tree_clinic/presentation/views/home_view.dart';
import 'package:tree_clinic/presentation/views/get_on_boarding_view.dart';
import 'package:tree_clinic/presentation/views/on_boarding_view.dart';
import 'package:tree_clinic/presentation/views/splash_view.dart';

abstract class AppRouter {
  static const kGetOnBoardingView = '/GetOnBoardingView';
  static const kHomeView = '/HomeView';
  static const kOnBoardingView = '/OnBoardingView';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kGetOnBoardingView,
        builder: (context, state) => const GetOnBoardingView(),
      ),
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(path: kOnBoardingView, builder: (context, state) =>  OnBoardingView()),
    ],
  );
}
