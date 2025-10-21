import 'package:go_router/go_router.dart';
import 'package:tree_clinic/presentation/views/home_view.dart';
import 'package:tree_clinic/presentation/views/on_boarding_view.dart';
import 'package:tree_clinic/presentation/views/splash_view.dart';

abstract class AppRouter {
   static const kOnBoardingView = '/OnBoardingView';
   static const kHomeView = '/HomeView';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(path: kOnBoardingView, builder: (context, state) => const OnBoardingView()),
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
    ],
  );
}
