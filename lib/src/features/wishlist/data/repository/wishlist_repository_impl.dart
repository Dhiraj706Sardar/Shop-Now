import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/exceptions.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:ecommerce_app/src/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/entity/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/repository/wishlist_repository.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource _localDataSource;

  WishlistRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Wishlist>>> getWishlistItems() async {
    try {
      final models = await _localDataSource.getWishlistItems();
      final entities = models.map((model) => model.toWishlist()).toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(Wishlist item) async {
    try {
      await _localDataSource.addToWishlist(item.toWishlistItemModel());
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(int productId) async {
    try {
      await _localDataSource.removeFromWishlist(productId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(int productId) async {
    try {
      final isIn = await _localDataSource.isInWishlist(productId);
      return Right(isIn);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
