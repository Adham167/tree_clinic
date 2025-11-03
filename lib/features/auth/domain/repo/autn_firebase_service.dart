import 'package:dartz/dartz.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';

abstract class AutnFirebaseService {
  Future<Either> signup(UserModel user);
}
