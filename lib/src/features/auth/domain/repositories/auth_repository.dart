import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, User>> signUpWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, User?>> getCurrentUser();

  Stream<User?> get authStateChanges;
}
