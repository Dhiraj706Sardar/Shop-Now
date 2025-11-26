import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/wishlist_item_model.dart';

part 'wishlist_state.freezed.dart';

@freezed
class WishlistState with _$WishlistState {
  const factory WishlistState.initial() = WishlistInitial;
  const factory WishlistState.loading() = WishlistLoading;
  const factory WishlistState.loaded({
    required List<WishlistItemModel> items,
  }) = WishlistLoaded;
  const factory WishlistState.error(String message) = WishlistError;
}
