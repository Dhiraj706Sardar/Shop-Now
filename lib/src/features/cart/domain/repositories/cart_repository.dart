import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/features/cart/domain/entity/Cart.dart';
import '../../../../core/errors/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, List<Cart>>> getCartItems();
  Future<Either<Failure, void>> addToCart(Cart cart);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}
