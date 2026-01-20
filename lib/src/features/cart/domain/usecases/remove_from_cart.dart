
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCart implements UseCase<void, int> {
   RemoveFromCart(this._cartRepository);
   final CartRepository _cartRepository;
   
   @override
   Future<Either<Failure, void>> call(int productId) async {
     return await _cartRepository.removeFromCart(productId);
   }
}