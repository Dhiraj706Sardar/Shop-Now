import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/repository/wishlist_repository.dart';

@lazySingleton
class IsInWishlist implements UseCase<bool, int> {
  final WishlistRepository _repository;

  IsInWishlist(this._repository);

  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await _repository.isInWishlist(params);
  }
}
