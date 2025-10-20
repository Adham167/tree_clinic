import 'package:go_router/go_router.dart';
import 'package:tree_clinic/features/splash/presentation/views/splash_view.dart';

abstract class AppRouter {
  // static const KOnboardingView = '/onboardingview';

  static final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
    ],
  );
}
