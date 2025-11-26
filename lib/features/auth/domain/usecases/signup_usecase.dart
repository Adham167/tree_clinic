import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/auth/data/model/user_model.dart';
import 'package:tree_clinic/features/auth/domain/repo/auth_repo.dart';

class SignupUsecase implements Usecase<Either, UserModel> {
  @override
  Future<Either> call({UserModel? params}) async {
    return await sl<AuthRepo>().signUp(params!);
  }
}
