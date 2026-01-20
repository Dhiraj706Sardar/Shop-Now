import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class SignUpWithEmail implements UseCase<User, SignUpParams> {
  final AuthRepository _repository;

  SignUpWithEmail(this._repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await _repository.signUpWithEmail(params.email, params.password);
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
