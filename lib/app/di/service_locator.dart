import 'package:get_it/get_it.dart';
import 'package:tree_clinic/features/auth/data/repo/auth_repo_impl.dart';
import 'package:tree_clinic/features/auth/data/source/auth_firebase_service_impl.dart';
import 'package:tree_clinic/features/auth/domain/repo/auth_repo.dart';
import 'package:tree_clinic/features/auth/domain/repo/autn_firebase_service.dart';
import 'package:tree_clinic/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signin_usecase.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signup_usecase.dart';
import 'package:tree_clinic/features/dashboard/data/repo/shop_repo_impl.dart';
import 'package:tree_clinic/features/dashboard/data/service/shop_firebase_service_impl.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_firebase_service.dart';
import 'package:tree_clinic/features/dashboard/domain/repo/shop_repo.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/add_shop_usecase.dart';
import 'package:tree_clinic/features/dashboard/domain/usecase/get_shop_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Services
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<ShopFirebaseService>(ShopFirebaseServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepo>(AuthRepoImpl());
  sl.registerSingleton<ShopRepo>(ShopRepoImpl());

  //UseCases
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<SigninUsecase>(SigninUsecase());
  sl.registerSingleton<GetCurrentUserUsecase>(GetCurrentUserUsecase());
  sl.registerSingleton<AddShopUsecase>(AddShopUsecase());
  sl.registerSingleton<GetShopUsecase>(GetShopUsecase());
}
