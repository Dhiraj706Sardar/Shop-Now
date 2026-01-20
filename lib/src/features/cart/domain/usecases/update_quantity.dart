import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantity implements UseCase<void, (int productId, int quantity)> {
  final CartRepository _cartRepository;
  UpdateQuantity(this._cartRepository);

  @override
  Future<Either<Failure, void>> call(
      (int productId, int quantity) params) async {
    return await _cartRepository.updateQuantity(params.$1, params.$2);
  }
}
