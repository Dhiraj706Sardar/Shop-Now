import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignInWithEmail implements UseCase<User, SignInParams> {
  final AuthRepository _repository;

  SignInWithEmail(this._repository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    return await _repository.signInWithEmail(params.email, params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
