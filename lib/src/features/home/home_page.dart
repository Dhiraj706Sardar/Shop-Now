import 'dart:async';
import 'package:ecommerce_app/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';
import 'package:ecommerce_app/src/core/widgets/shimmer_widgets.dart';
import 'package:ecommerce_app/src/core/widgets/text_fields.dart';
import 'package:ecommerce_app/src/core/widgets/product_card.dart';
import 'package:ecommerce_app/src/core/widgets/lottie_widgets.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_event.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_state.dart';
import 'package:ecommerce_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/src/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/cubit/wishlist_state.dart';
import 'package:ecommerce_app/src/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:ecommerce_app/src/router/app_router.dart';

// Enum for sorting options
enum SortOrder { lowToHigh, highToLow }

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Current sorting order
  SortOrder? _sortOrder;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Load products and categories on init
    context.read<ProductBloc>().add(const LoadProducts());
    context.read<ProductBloc>().add(const LoadCategories());
    context.read<WishlistCubit>().loadWishlist();

    // Add search listener with debouncing
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProductBloc>().add(SearchProducts(_searchController.text));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back! 👋',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: AppTheme.spacingXs),
                            Text(
                              'Find your perfect products',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        // Profile/Cart Icons
                        Row(
                          children: [
                            _buildIconButton(
                              Icons.shopping_cart_outlined,
                              () => context.router.push(const CartRoute()),
                            ),
                            const SizedBox(width: AppTheme.spacingSm),
                            _buildIconButton(
                              Icons.person_outline,
                              () => context.router.push(const ProfileRoute()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    // Search Bar
                    SearchTextField(
                      controller: _searchController,
                      hint: 'Search products...',
                      onChanged: (value) {
                        context.read<ProductBloc>().add(SearchProducts(value));
                      },
                      onFilterTap: () {
                        _showFilterBottomSheet();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    child: Text(
                      'Categories',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const CategoryListShimmer();
                      } else if (state is ProductsLoaded &&
                          state.categories.isNotEmpty) {
                        return _buildCategoryList(['All', ...state.categories]);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            // Products Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Products',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<ProductBloc>()
                            .add(LoadProductsByCategory(_selectedCategory));
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
            ),

            // Products Grid
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const SliverFillRemaining(
                    child: ProductGridShimmer(),
                  );
                } else if (state is ProductsLoaded) {
                  // Apply sorting based on _sortOrder
                  List<ProductModel> displayedProducts =
                      List.from(state.products);
                  if (_sortOrder == SortOrder.lowToHigh) {
                    displayedProducts
                        .sort((a, b) => a.price.compareTo(b.price));
                  } else if (_sortOrder == SortOrder.highToLow) {
                    displayedProducts
                        .sort((a, b) => b.price.compareTo(a.price));
                  }

                  if (displayedProducts.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyStateWidget(
                        title: 'No Products Found',
                        message:
                            'We couldn\'t find any products at the moment.',
                        icon: Icons.inventory_2_outlined,
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: AppTheme.spacingMd,
                        mainAxisSpacing: AppTheme.spacingMd,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = displayedProducts[index].toEntity();
                          final productModel = displayedProducts[index];

                          return BlocBuilder<WishlistCubit, WishlistState>(
                            builder: (context, wishlistState) {
                              bool isFavorite = false;

                              wishlistState.maybeWhen(
                                loaded: (items) {
                                  isFavorite = items.any(
                                    (item) => item.productId == productModel.id,
                                  );
                                },
                                orElse: () {},
                              );

                              return ProductCard(
                                product: product,
                                isFavorite: isFavorite,
                                onTap: () {
                                  context.router.push(
                                    ProductDetailsRoute(productId: product.id),
                                  );
                                },
                                onAddToCart: () {
                                  final cartItem = CartItemModel(
                                    productId: productModel.id,
                                    title: productModel.title,
                                    price: productModel.price.toDouble(),
                                    image: productModel.image,
                                    quantity: 1,
                                  );
                                  context.read<CartCubit>().addToCart(cartItem);
                                  _showAddedToCartSnackbar(context);
                                },
                                onToggleFavorite: () async {
                                  final wishlistItem = WishlistItemModel(
                                    productId: productModel.id,
                                    title: productModel.title,
                                    price: productModel.price.toDouble(),
                                    image: productModel.image,
                                    addedAt: DateTime.now(),
                                  );

                                  await context
                                      .read<WishlistCubit>()
                                      .toggleWishlist(wishlistItem);

                                  if (!isFavorite) {
                                    _showAddedToWishlistSnackbar(context);
                                  }
                                },
                              );
                            },
                          );
                        },
                        childCount: displayedProducts.length,
                      ),
                    ),
                  );
                } else if (state is ProductError) {
                  return SliverFillRemaining(
                    child: ErrorStateWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<ProductBloc>().add(const LoadProducts());
                      },
                    ),
                  );
                }
                return const SliverFillRemaining(
                  child: Center(child: Text('Start browsing products')),
                );
              },
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppTheme.spacingXl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }

  Widget _buildCategoryList(List<String> categories) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              // Filter products by category
              context.read<ProductBloc>().add(LoadProductsByCategory(category));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: AppTheme.spacingMd,
              ),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                color: isSelected ? null : AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
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

  void _showAddedToWishlistSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.red),
            SizedBox(width: AppTheme.spacingMd),
            Text(
              'Added to wishlist!',
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingSm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort By Price',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Sort Options
              _buildSortOption(
                context: ctx,
                icon: Icons.arrow_upward,
                title: 'Price: Low to High',
                subtitle: 'Sort products from lowest to highest price',
                isSelected: _sortOrder == SortOrder.lowToHigh,
                onTap: () {
                  setState(() {
                    _sortOrder = SortOrder.lowToHigh;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: AppTheme.spacingMd),

              _buildSortOption(
                context: ctx,
                icon: Icons.arrow_downward,
                title: 'Price: High to Low',
                subtitle: 'Sort products from highest to lowest price',
                isSelected: _sortOrder == SortOrder.highToLow,
                onTap: () {
                  setState(() {
                    _sortOrder = SortOrder.highToLow;
                  });
                  Navigator.of(ctx).pop();
                },
              ),
              const SizedBox(height: AppTheme.spacingMd),

              _buildSortOption(
                context: ctx,
                icon: Icons.clear,
                title: 'Clear Filter',
                subtitle: 'Show products in default order',
                isSelected: _sortOrder == null,
                onTap: () {
                  setState(() {
                    _sortOrder = null;
                  });
                  Navigator.of(ctx).pop();
                },
              ),

              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.surfaceColor,
          border: isSelected
              ? null
              : Border.all(
                  color: AppTheme.textSecondary.withOpacity(0.2),
                  width: 1,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
