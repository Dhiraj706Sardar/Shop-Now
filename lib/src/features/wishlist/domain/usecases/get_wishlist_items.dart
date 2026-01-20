import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/entity/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/repository/wishlist_repository.dart';

@lazySingleton
class GetWishlistItems implements UseCase<List<Wishlist>, NoParams> {
  final WishlistRepository _repository;

  GetWishlistItems(this._repository);

  @override
  Future<Either<Failure, List<Wishlist>>> call(NoParams params) async {
    return await _repository.getWishlistItems();
  }
}
