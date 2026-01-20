import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/repository/wishlist_repository.dart';

@lazySingleton
class RemoveFromWishlist implements UseCase<void, int> {
  final WishlistRepository _repository;

  RemoveFromWishlist(this._repository);

  @override
  Future<Either<Failure, void>> call(int params) async {
    return await _repository.removeFromWishlist(params);
  }
}
