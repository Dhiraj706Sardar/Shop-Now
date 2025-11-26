import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
@HiveType(typeId: 0)
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    @HiveField(0) required int productId,
    @HiveField(1) required String title,
    @HiveField(2) required double price,
    @HiveField(3) required String image,
    @HiveField(4) @Default(1) int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
