import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../../../core/widgets/lottie_widgets.dart';
import '../../../../router/app_router.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Show confirmation dialog before clearing
              _showClearCartDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          switch (state) {
            case CartLoading():
              return const CartListShimmer();
            case CartLoaded():
              if (state.items.isEmpty) {
                return EmptyCartWidget(
                  onShopNow: () =>
                      context.router.replaceAll([const HomeRoute()]),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      itemCount: state.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppTheme.spacingMd),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Dismissible(
                          key: Key(item.productId.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                                right: AppTheme.spacingLg),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg),
                            ),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) {
                            context
                                .read<CartCubit>()
                                .removeFromCart(item.productId);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppTheme.spacingMd),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceColor,
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusLg),
                              boxShadow: AppTheme.cardShadow,
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppTheme.radiusMd),
                                  child: CachedNetworkImage(
                                    imageUrl: item.image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppTheme.backgroundColor,
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingMd),

                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                          height: AppTheme.spacingXs),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(
                                          height: AppTheme.spacingSm),

                                      // Quantity Controls
                                      Row(
                                        children: [
                                          _buildQuantityButton(
                                            icon: Icons.remove,
                                            onPressed: () {
                                              context
                                                  .read<CartCubit>()
                                                  .updateQuantity(
                                                    item.productId,
                                                    item.quantity - 1,
                                                  );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppTheme.spacingMd,
                                            ),
                                            child: Text(
                                              '${item.quantity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                          _buildQuantityButton(
                                            icon: Icons.add,
                                            onPressed: () {
                                              context
                                                  .read<CartCubit>()
                                                  .updateQuantity(
                                                    item.productId,
                                                    item.quantity + 1,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Total & Checkout
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusXl),
                      ),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '\$${state.total.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          PrimaryButton(
                            text: 'Proceed to Checkout',
                            onPressed: () {
                              context.router.push(const CheckoutRoute());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.pop(context);
            },
            child: const Text('Clear',
                style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
