import 'package:get_it/get_it.dart';
import 'package:tree_clinic/features/auth/data/repo/auth_repo_impl.dart';
import 'package:tree_clinic/features/auth/data/source/auth_firebase_service_impl.dart';
import 'package:tree_clinic/features/auth/domain/repo/auth_repo.dart';
import 'package:tree_clinic/features/auth/domain/repo/autn_firebase_service.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signin_usecase.dart';
import 'package:tree_clinic/features/auth/domain/usecases/signup_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //Services
  sl.registerSingleton<AutnFirebaseService>(AuthFirebaseServiceImpl());

  // Repositories
  sl.registerSingleton<AuthRepo>(AuthRepoImpl());

  //UseCases
  sl.registerSingleton<SignupUsecase>(SignupUsecase());
  sl.registerSingleton<SigninUsecase>(SigninUsecase());
}
