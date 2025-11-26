import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<Either<Failure, OrderModel>> createOrder(OrderModel order);
  Future<Either<Failure, List<OrderModel>>> getOrders(String userId);
  Future<Either<Failure, OrderModel>> getOrder(String orderId);
}
