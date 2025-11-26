import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/cart_item_model.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(const CartInitial());

  Future<void> loadCart() async {
    emit(const CartLoading());

    final result = await _repository.getCartItems();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) {
        final total = _calculateTotal(items);
        emit(CartLoaded(items: items, total: total));
      },
    );
  }

  Future<void> addToCart(CartItemModel item) async {
    final result = await _repository.addToCart(item);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> removeFromCart(int productId) async {
    final result = await _repository.removeFromCart(productId);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final result = await _repository.updateQuantity(productId, quantity);

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  Future<void> clearCart() async {
    final result = await _repository.clearCart();

    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => loadCart(),
    );
  }

  double _calculateTotal(List<CartItemModel> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
