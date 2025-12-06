import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:ecommerce_app/src/core/constants/hive_constants.dart';
import 'package:ecommerce_app/src/core/errors/exceptions.dart';
import 'package:ecommerce_app/src/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(@Named(HiveConstants.cartBox) this._cartBox);
  final Box<CartItemModel> _cartBox;
  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      return _cartBox.values.toList();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    try {
      final existingItem = _cartBox.get(item.productId);
      if (existingItem != null) {
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
        await _cartBox.put(item.productId, updatedItem);
      } else {
        await _cartBox.put(item.productId, item);
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      await _cartBox.delete(productId);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      final item = _cartBox.get(productId);
      if (item != null) {
        final updatedItem = item.copyWith(quantity: quantity);
        await _cartBox.put(productId, updatedItem);
      }
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _cartBox.clear();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
