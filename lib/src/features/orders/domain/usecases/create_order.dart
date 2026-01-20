import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/orders/domain/entity/Order.dart' as order;
import 'package:ecommerce_app/src/features/orders/domain/repositories/order_repository.dart';

class CreateOrder implements UseCase<order.Order, order.Order> {
  final OrderRepository _orderRepository;
  const CreateOrder(this._orderRepository);

  @override
  Future<Either<Failure,order.Order >> call(order.Order order) async {
    return await _orderRepository.createOrder(order);
  }
}