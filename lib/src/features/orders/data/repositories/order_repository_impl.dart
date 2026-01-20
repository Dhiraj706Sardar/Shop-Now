import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/errors/exceptions.dart';
import 'package:ecommerce_app/src/core/errors/failures.dart';
import 'package:ecommerce_app/src/features/orders/domain/repositories/order_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:ecommerce_app/src/features/orders/data/models/order_model.dart';
import 'package:ecommerce_app/src/features/orders/domain/entity/Order.dart'
    as order;

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, order.Order>> createOrder(order.Order order) async {
    try {
      final createdOrder =
          await _remoteDataSource.createOrder(order.toOrderModel());
      return Right(createdOrder.toOrder());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<order.Order>>> getOrders(String userId) async {
    try {
      final orders = await _remoteDataSource.getOrders(userId);
      return Right(orders.map((order) => order.toOrder()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, order.Order>> getOrder(String orderId) async {
    try {
      final order = await _remoteDataSource.getOrder(orderId);
      return Right(order.toOrder());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
