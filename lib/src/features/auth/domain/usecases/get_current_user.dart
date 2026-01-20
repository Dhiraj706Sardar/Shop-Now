import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await _repository.getCurrentUser();
  }
}
