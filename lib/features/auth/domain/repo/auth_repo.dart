import 'package:dartz/dartz.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';

abstract class AuthRepo {
  Future<Either> signUp(UserModel user);
}
