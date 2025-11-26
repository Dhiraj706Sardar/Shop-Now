import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/lottie_widgets.dart';
import '../../../../router/app_router.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

@RoutePage()
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (items) => items.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _showClearDialog(context),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('Loading...')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (items) {
              if (items.isEmpty) {
                return const EmptyStateWidget(
                  title: 'Your Wishlist is Empty',
                  message:
                      'Add items to your wishlist by tapping the heart icon on products.',
                  icon: Icons.favorite_border,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppTheme.spacingMd),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildWishlistCard(context, item);
                },
              );
            },
            error: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => context.read<WishlistCubit>().loadWishlist(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWishlistCard(BuildContext context, item) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.router.push(
            ProductDetailsRoute(productId: item.productId),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  color: AppTheme.backgroundColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      'Added ${_formatDate(item.addedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      context
                          .read<WishlistCubit>()
                          .removeFromWishlist(item.productId);
                      _showRemovedSnackbar(context);
                    },
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final cartItem = CartItemModel(
                        productId: item.productId,
                        title: item.title,
                        price: item.price,
                        image: item.image,
                        quantity: 1,
                      );
                      context.read<CartCubit>().addToCart(cartItem);
                      _showAddedToCartSnackbar(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text(
          'Are you sure you want to remove all items from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<WishlistCubit>().clearWishlist();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showRemovedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor),
            SizedBox(width: AppTheme.spacingMd),
            Text(
              'Removed from wishlist',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddedToCartSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor),
            SizedBox(width: AppTheme.spacingMd),
            Text(
              'Added to cart successfully!',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
