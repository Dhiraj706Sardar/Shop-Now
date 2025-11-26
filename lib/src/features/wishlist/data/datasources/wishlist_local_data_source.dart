import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/constants/hive_constants.dart';
import 'package:ecommerce_app/src/core/errors/exceptions.dart';
import 'package:ecommerce_app/src/features/wishlist/data/models/wishlist_item_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<WishlistItemModel>> getWishlistItems();
  Future<void> addToWishlist(WishlistItemModel item);
  Future<void> removeFromWishlist(int productId);
  Future<bool> isInWishlist(int productId);
}

@LazySingleton(as: WishlistLocalDataSource)
class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  WishlistLocalDataSourceImpl(
      @Named(HiveConstants.wishlistBox) this._wishlistBox);
  final Box<WishlistItemModel> _wishlistBox;

  @override
  Future<List<WishlistItemModel>> getWishlistItems() async {
    try {
      return _wishlistBox.values.toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> addToWishlist(WishlistItemModel item) async {
    try {
      await _wishlistBox.put(item.productId, item);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> removeFromWishlist(int productId) async {
    try {
      await _wishlistBox.delete(productId);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<bool> isInWishlist(int productId) async {
    try {
      return _wishlistBox.containsKey(productId);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
