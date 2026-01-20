import 'package:ecommerce_app/src/features/auth/domain/entity/user.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/user_model.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class ListenToAuthChanges {
  final AuthRepository _repository;

  ListenToAuthChanges(this._repository);

  Stream<User?> call(NoParams params) {
    return _repository.authStateChanges;
  }
}
