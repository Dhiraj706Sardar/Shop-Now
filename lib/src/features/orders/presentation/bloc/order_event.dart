import 'package:equatable/equatable.dart';
import '../../data/models/order_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrder extends OrderEvent {
  final OrderModel order;

  const CreateOrder(this.order);

  @override
  List<Object?> get props => [order];
}

class LoadOrders extends OrderEvent {
  final String userId;

  const LoadOrders(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadOrder extends OrderEvent {
  final String orderId;

  const LoadOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
