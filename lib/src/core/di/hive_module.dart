import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../constants/hive_constants.dart';
import '../../features/cart/data/models/cart_item_model.dart';
import '../../features/wishlist/data/models/wishlist_item_model.dart';

@module
abstract class HiveModule {
  @preResolve
  @Named(HiveConstants.cartBox)
  Future<Box<CartItemModel>> cartBox() async {
    await Hive.initFlutter();
    // Register adapter for cart items
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CartItemModelAdapter());
    }
    return await Hive.openBox<CartItemModel>(HiveConstants.cartBox);
  }

  @preResolve
  @Named(HiveConstants.wishlistBox)
  Future<Box<WishlistItemModel>> wishlistBox() async {
    await Hive.initFlutter();
    // Register adapter for wishlist items
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(WishlistItemModelAdapter());
    }
    return await Hive.openBox<WishlistItemModel>(HiveConstants.wishlistBox);
  }
}
