import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/features/orders/domain/entity/Order.dart' as order;

abstract class OrderRepository {
  Future<Either<Failure, order.Order>> createOrder(order.Order order);
  Future<Either<Failure, List<order.Order>>> getOrders(String userId);
  Future<Either<Failure, order.Order>> getOrder(String orderId);
}
