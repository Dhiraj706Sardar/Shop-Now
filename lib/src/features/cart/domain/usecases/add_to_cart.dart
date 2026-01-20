import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/cart/domain/entity/Cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/repositories/cart_repository.dart';

class AddToCart implements UseCase<void , Cart> {

  AddToCart(this._cartRepository);

  final CartRepository _cartRepository;

  @override
  Future<Either<Failure, void>> call(Cart cart) {
    return _cartRepository.addToCart(cart);
  }
}