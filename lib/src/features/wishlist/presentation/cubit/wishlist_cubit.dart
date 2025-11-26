import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/datasources/wishlist_local_data_source.dart';
import '../../data/models/wishlist_item_model.dart';
import 'wishlist_state.dart';

@injectable
class WishlistCubit extends Cubit<WishlistState> {
  final WishlistLocalDataSource _dataSource;

  WishlistCubit(this._dataSource) : super(const WishlistState.initial());

  Future<void> loadWishlist() async {
    emit(const WishlistState.loading());

    try {
      final items = await _dataSource.getWishlistItems();
      emit(WishlistState.loaded(items: items));
    } catch (e) {
      emit(WishlistState.error(e.toString()));
    }
  }

  Future<void> addToWishlist(WishlistItemModel item) async {
    try {
      await _dataSource.addToWishlist(item);
      await loadWishlist();
    } catch (e) {
      emit(WishlistState.error(e.toString()));
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      await _dataSource.removeFromWishlist(productId);
      await loadWishlist();
    } catch (e) {
      emit(WishlistState.error(e.toString()));
    }
  }

  Future<void> toggleWishlist(WishlistItemModel item) async {
    try {
      final isInWishlist = await _dataSource.isInWishlist(item.productId);
      if (isInWishlist) {
        await removeFromWishlist(item.productId);
      } else {
        await addToWishlist(item);
      }
    } catch (e) {
      emit(WishlistState.error(e.toString()));
    }
  }

  Future<bool> isInWishlist(int productId) async {
    try {
      return await _dataSource.isInWishlist(productId);
    } catch (e) {
      return false;
    }
  }

  Future<void> clearWishlist() async {
    try {
      final items = await _dataSource.getWishlistItems();
      for (var item in items) {
        await _dataSource.removeFromWishlist(item.productId);
      }
      await loadWishlist();
    } catch (e) {
      emit(WishlistState.error(e.toString()));
    }
  }
}
