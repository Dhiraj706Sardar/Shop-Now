import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/wishlist_item_model.dart';
import '../../domain/usecases/add_to_wishlist.dart';
import '../../domain/usecases/get_wishlist_items.dart';
import '../../domain/usecases/is_in_wishlist.dart';
import '../../domain/usecases/remove_from_wishlist.dart';
import 'wishlist_state.dart';

@injectable
class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistItems _getWishlistItems;
  final AddToWishlist _addToWishlist;
  final RemoveFromWishlist _removeFromWishlist;
  final IsInWishlist _isInWishlist;

  WishlistCubit(
    this._getWishlistItems,
    this._addToWishlist,
    this._removeFromWishlist,
    this._isInWishlist,
  ) : super(const WishlistState.initial());

  Future<void> loadWishlist() async {
    emit(const WishlistState.loading());

    final result = await _getWishlistItems(NoParams());
    result.fold(
      (failure) => emit(WishlistState.error(failure.message)),
      (items) => emit(WishlistState.loaded(
        items: items.map((e) => e.toWishlistItemModel()).toList(),
      )),
    );
  }

  Future<void> addToWishlist(WishlistItemModel item) async {
    final result = await _addToWishlist(item.toWishlist());
    result.fold(
      (failure) => emit(WishlistState.error(failure.message)),
      (_) => loadWishlist(),
    );
  }

  Future<void> removeFromWishlist(int productId) async {
    final result = await _removeFromWishlist(productId);
    result.fold(
      (failure) => emit(WishlistState.error(failure.message)),
      (_) => loadWishlist(),
    );
  }

  Future<void> toggleWishlist(WishlistItemModel item) async {
    final result = await _isInWishlist(item.productId);
    result.fold(
      (failure) => emit(WishlistState.error(failure.message)),
      (isIn) async {
        if (isIn) {
          await removeFromWishlist(item.productId);
        } else {
          await addToWishlist(item);
        }
      },
    );
  }

  Future<bool> isInWishlist(int productId) async {
    final result = await _isInWishlist(productId);
    return result.fold(
      (failure) => false,
      (isIn) => isIn,
    );
  }

  Future<void> clearWishlist() async {
    final result = await _getWishlistItems(NoParams());
    result.fold(
      (failure) => emit(WishlistState.error(failure.message)),
      (items) async {
        for (var item in items) {
          await _removeFromWishlist(item.productId);
        }
        await loadWishlist();
      },
    );
  }
}
