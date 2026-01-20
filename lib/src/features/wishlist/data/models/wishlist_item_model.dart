import 'package:ecommerce_app/src/features/wishlist/domain/entity/wishlist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'wishlist_item_model.freezed.dart';
part 'wishlist_item_model.g.dart';

@freezed
@HiveType(typeId: 1)
class WishlistItemModel with _$WishlistItemModel {
  const factory WishlistItemModel({
    @HiveField(0) required int productId,
    @HiveField(1) required String title,
    @HiveField(2) required double price,
    @HiveField(3) required String image,
    @HiveField(4) required DateTime addedAt,
  }) = _WishlistItemModel;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);
}

extension WishlistItemModelX on WishlistItemModel {
  Wishlist toWishlist() {
    return Wishlist(
      productId: productId,
      title: title,
      price: price,
      image: image,
      addedAt: addedAt,
    );
  }
}

extension WishlistX on Wishlist {
  WishlistItemModel toWishlistItemModel() {
    return WishlistItemModel(
      productId: productId,
      title: title,
      price: price,
      image: image,
      addedAt: addedAt,
    );
  }
}
