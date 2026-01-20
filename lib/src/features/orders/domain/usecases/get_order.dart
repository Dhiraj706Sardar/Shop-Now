import 'package:ecommerce_app/src/core/usecases/usecase.dart';
import 'package:ecommerce_app/src/features/orders/domain/entity/Order.dart'
    as order;
import 'package:ecommerce_app/src/features/orders/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';

class GetOrder implements UseCase<order.Order, String> {
  const GetOrder(this._orderRepository);
  final OrderRepository _orderRepository;

  @override
  Future<Either<Failure, order.Order>> call(String orderId) async {
    return await _orderRepository.getOrder(orderId);
  }
}
