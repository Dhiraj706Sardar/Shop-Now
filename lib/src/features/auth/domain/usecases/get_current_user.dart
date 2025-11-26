import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class GetCurrentUser implements UseCase<UserModel?, NoParams> {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  @override
  Future<Either<Failure, UserModel?>> call(NoParams params) async {
    return await _repository.getCurrentUser();
  }
}
