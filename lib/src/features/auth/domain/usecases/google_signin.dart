// import 'package:dartz/dartz.dart';
// import 'package:ecommerce_app/src/core/errors/failures.dart';
// import 'package:ecommerce_app/src/core/usecases/usecase.dart';
// import 'package:ecommerce_app/src/features/auth/data/datasources/auth_remote_data_source.dart';

// class GoogleSignin implements UseCase<void, NoParams> {
//   final AuthRemoteDataSource _remoteDataSource;

//   GoogleSignin(this._remoteDataSource);

//   @override
//   Future<Either<Failure, void>> call(NoParams params) async {
//     return await _remoteDataSource
//         .signWithGoogle()
//         .then((value) => Right(value));
//   }
// }
