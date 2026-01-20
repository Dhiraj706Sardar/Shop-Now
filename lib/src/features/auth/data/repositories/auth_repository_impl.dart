import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final usermodel =
          await _remoteDataSource.signInWithEmail(email, password);
      return Right(usermodel.toUser());
    } on EmailVerificationRequiredException catch (e) {
      return Left(EmailVerificationRequiredFailure(e.email));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      final usermodel =
          await _remoteDataSource.signUpWithEmail(email, password);
      return Right(usermodel.toUser());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on EmailVerificationRequiredException catch (e) {
      return Left(EmailVerificationRequiredFailure(e.email));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final usermodel = await _remoteDataSource.getCurrentUser();
      return Right(usermodel?.toUser());
    } on EmailVerificationRequiredException catch (e) {
      return Left(EmailVerificationRequiredFailure(e.email));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges
      .map((usermodel) => usermodel?.toUser());
}
