import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/entity/wishlist.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<Wishlist>>> getWishlistItems();
  Future<Either<Failure, void>> addToWishlist(Wishlist item);
  Future<Either<Failure, void>> removeFromWishlist(int productId);
  Future<Either<Failure, bool>> isInWishlist(int productId);
}
