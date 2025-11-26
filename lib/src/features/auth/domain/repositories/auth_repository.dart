import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, UserModel>> signUpWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserModel?>> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}
