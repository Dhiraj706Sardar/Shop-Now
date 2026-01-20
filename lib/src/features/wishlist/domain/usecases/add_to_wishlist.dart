import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/entity/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/repository/wishlist_repository.dart';

@lazySingleton
class AddToWishlist implements UseCase<void, Wishlist> {
  final WishlistRepository _repository;

  AddToWishlist(this._repository);

  @override
  Future<Either<Failure, void>> call(Wishlist params) async {
    return await _repository.addToWishlist(params);
  }
}
