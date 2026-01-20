import 'package:ecommerce_app/src/features/orders/domain/entity/Order.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../cart/data/models/cart_item_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    required List<CartItemModel> items,
    required double total,
    required OrderStatus status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('shipped')
  shipped,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
}

extension OrderExtension on OrderModel {
  Order toOrder() {
    return Order(
      id: id,
      userId: userId,
      items: items.map((item) => item.toCart()).toList(),
      total: total,
      status: status.name,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

extension OrderModelExtension on Order {
  OrderModel toOrderModel() {
    return OrderModel(
      id: id,
      userId: userId,
      items: items.map((item) => item.toCartItemModel()).toList(),
      total: total,
      status: OrderStatus.values.firstWhere((e) => e.name == status),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
