import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/auth/data/model/user_signIn_model.dart';
import 'package:tree_clinic/features/auth/domain/repo/auth_repo.dart';

class SigninUsecase extends Usecase<Either, UserSigninModel> {
  @override
  Future<Either> call({UserSigninModel? params}) {
    return sl<AuthRepo>().signIn(params!);
  }
}
