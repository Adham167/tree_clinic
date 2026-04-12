import 'package:dartz/dartz.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/core/usecases/usecase.dart';
import 'package:tree_clinic/features/auth/domain/repo/auth_repo.dart';

class GetCurrentUserUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either<dynamic, dynamic>> call({params}) async {
    return await sl<AuthRepo>().getCurrentUser();
  }
}
