import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
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
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/add_shop_usecase.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/get_shop_usecase.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_product_cubit/add_product_cubit.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/add_shop_cubit/add_shop_cubit.dart';
import 'package:tree_clinic/features/dashboard/presentation/manager/get_shop_cubit/get_shop_cubit.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/add_product_view.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/create_shop_view.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/manage_products_view.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/merchant_order_requests_view.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/my_shop_view.dart';
import 'package:tree_clinic/features/dashboard/presentation/views/sales_analytics_view.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';
import 'package:tree_clinic/features/shopping/presentation/views/product_details_view.dart';
import 'package:tree_clinic/presentation/main_navigation.dart';
import 'package:tree_clinic/presentation/views/on_boarding_view.dart';
import 'package:tree_clinic/presentation/views/splash_view.dart';

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
  static const kDashboardView = '/DashboardView';
  static const kCreateShopView = '/CreateShopView';
  static const kMyShopView = '/MyShopView';
  static const kaddProductView = '/AddProductView';
  static const kManageProductsView = '/ManageProductsView';
  static const kSalesAnalyticsView = '/SalesAnalyticsView';
  static const kMerchantOrderRequestsView = '/MerchantOrderRequestsView';
  static const kProductDetailsView = '/ProductDetailsView';
  static const _authOnlyPaths = {
    kGetOnBoardingView,
    kAuthCoice,
    kRegisterView,
    kLoginView,
    kSignUpView,
    kForgotPassword,
    kNewPasswordView,
    kSuccessResetPassword,
    kSucessSignUp,
  };
  static const _protectedPaths = {
    kMainNavigation,
    kDashboardView,
    kCreateShopView,
    kMyShopView,
    kaddProductView,
    kManageProductsView,
    kSalesAnalyticsView,
    kMerchantOrderRequestsView,
  };

  static final router = GoRouter(
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final currentPath = state.matchedLocation;

      if (isLoggedIn && _authOnlyPaths.contains(currentPath)) {
        return kMainNavigation;
      }

      if (!isLoggedIn && _protectedPaths.contains(currentPath)) {
        return kAuthCoice;
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kaddProductView,
        builder: (context, state) {
          final product =
              state.extra is ProductModel ? state.extra as ProductModel : null;

          return BlocProvider(
            create: (context) => AddProductCubit(),
            child: AddProductView(initialProduct: product),
          );
        },
      ),
      GoRoute(
        path: kGetOnBoardingView,
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: kProductDetailsView,
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailsView(product: product);
        },
      ),
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

      GoRoute(
        path: kCreateShopView,
        builder: (context, state) {
          final shop =
              state.extra is ShopEntity ? state.extra as ShopEntity : null;

          return MultiBlocProvider(
            providers: [
              BlocProvider<AddShopCubit>(
                create:
                    (context) =>
                        AddShopCubit(addShopUsecase: sl<AddShopUsecase>()),
              ),
              BlocProvider<GetShopCubit>(
                create:
                    (context) =>
                        GetShopCubit(getShopUsecase: sl<GetShopUsecase>()),
              ),
            ],
            child: CreateShopView(initialShop: shop),
          );
        },
      ),
      GoRoute(
        path: kDashboardView,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider<AddShopCubit>(
                  create:
                      (context) =>
                          AddShopCubit(addShopUsecase: sl<AddShopUsecase>()),
                ),
                BlocProvider<GetShopCubit>(
                  create:
                      (context) =>
                          GetShopCubit(getShopUsecase: sl<GetShopUsecase>()),
                ),
                BlocProvider<AddProductCubit>(
                  create: (context) => AddProductCubit(),
                ),
              ],
              child: const DashboardView(),
            ),
      ),
      GoRoute(
        path: kMyShopView,
        builder: (context, state) {
          final shop = state.extra as ShopEntity;

          return BlocProvider(
            create:
                (context) => AddShopCubit(addShopUsecase: sl<AddShopUsecase>()),
            child: MyShopView(shop: shop),
          );
        },
      ),
      GoRoute(
        path: kManageProductsView,
        builder: (context, state) {
          final shop = state.extra as ShopEntity;

          return BlocProvider(
            create: (context) => AddProductCubit(),
            child: ManageProductsView(shop: shop),
          );
        },
      ),
      GoRoute(
        path: kSalesAnalyticsView,
        builder: (context, state) {
          final shop = state.extra as ShopEntity;

          return SalesAnalyticsView(shop: shop);
        },
      ),
      GoRoute(
        path: kMerchantOrderRequestsView,
        builder: (context, state) {
          final shop = state.extra as ShopEntity;

          return MerchantOrderRequestsView(shop: shop);
        },
      ),
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
