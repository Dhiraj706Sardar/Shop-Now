import 'package:equatable/equatable.dart';
import 'package:ecommerce_app/src/features/cart/data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {

  const CartLoaded({required this.items, required this.total});
  final List<CartItemModel> items;
  final double total;

  @override
  List<Object?> get props => [items, total];
}

class CartError extends CartState {

  const CartError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
