import 'package:dartz/dartz.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';

abstract class AuthRepo {
  Future<Either> signUp(UserModel user);
  Future<Either> signIn(UserSigninModel user);
  Future<Either> signInWithGoogle();
}
