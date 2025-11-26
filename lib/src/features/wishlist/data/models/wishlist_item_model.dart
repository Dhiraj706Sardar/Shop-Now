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
