import 'package:ecommerce_app/src/features/orders/data/models/order_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

@injectable
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(this._repository) : super(const OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrder>(_onLoadOrder);
  }
  final OrderRepository _repository;

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    if (event.order.userId.isEmpty) {
      emit(const OrderError('Invalid User ID'));
      return;
    }
    emit(const OrderLoading());

    final result = await _repository.createOrder(event.order.toOrder());

    result.fold(
      (failure) => {
        debugPrint(failure.message),
        emit(OrderError(failure.message)),
      },
      (order) {
        debugPrint(order.toString());
        emit(OrderCreated(order));
      },
    );
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) async {
    if (event.userId.isEmpty) {
      emit(const OrderError('Invalid User ID'));
      return;
    }
    emit(const OrderLoading());

    final result = await _repository.getOrders(event.userId);

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onLoadOrder(
    LoadOrder event,
    Emitter<OrderState> emit,
  ) async {
    if (event.orderId.isEmpty) {
      emit(const OrderError('Invalid Order ID'));
      return;
    }
    emit(const OrderLoading());

    final result = await _repository.getOrder(event.orderId);

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderLoaded(order)),
    );
  }
}
