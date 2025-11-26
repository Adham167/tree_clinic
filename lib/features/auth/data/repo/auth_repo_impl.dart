import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';
import 'package:tree_clinic/features/auth/domain/repo/auth_repo.dart';
import 'package:tree_clinic/features/auth/domain/repo/autn_firebase_service.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either> signUp(UserModel user) async {
    return await sl<AutnFirebaseService>().signup(user);
  }

  @override
  Future<Either> signIn(UserSigninModel user) async {
    return await sl<AutnFirebaseService>().signIn(user);
  }
  
  @override
  Future<Either> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
}
