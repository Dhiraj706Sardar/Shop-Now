import 'package:ecommerce_app/src/features/cart/domain/entity/Cart.dart';

class Order {
  const Order({
    this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String userId;
  final List<Cart> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
}
