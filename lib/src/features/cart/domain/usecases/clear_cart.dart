import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';

class ClearCart implements UseCase<void, NoParams> {

  ClearCart(this._repository);
  final CartRepository _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.clearCart();
  }
} 
