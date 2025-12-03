import 'package:ecommerce_app/src/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';
import 'package:ecommerce_app/src/core/widgets/buttons.dart';
import 'package:ecommerce_app/src/core/widgets/shimmer_widgets.dart';
import 'package:ecommerce_app/src/core/widgets/lottie_widgets.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_event.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_state.dart';
import 'package:ecommerce_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/src/features/cart/data/models/cart_item_model.dart';

@RoutePage()
class ProductDetailsPage extends StatefulWidget {
  final int productId;

  const ProductDetailsPage({
    super.key,
    @PathParam('id') required this.productId,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProduct(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const _ProductDetailsShimmer();
            } else if (state is ProductLoaded) {
              final product = state.product.toEntity();
              return CustomScrollView(
                slivers: [
                  // App Bar & Image Carousel
                  SliverAppBar(
                    expandedHeight: 350,
                    pinned: true,
                    backgroundColor: AppTheme.backgroundColor,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            context.router.pop();
                            context
                                .read<ProductBloc>()
                                .add(const LoadProducts());
                          },
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 350,
                              viewportFraction: 1.0,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                            ),
                            items: [product.imageUrl].map((url) {
                              return Hero(
                                tag: 'product-${product.id}',
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  placeholder: (context, url) => Container(
                                    color: AppTheme.surfaceColor,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: AnimatedSmoothIndicator(
                                activeIndex: _currentImageIndex,
                                count:
                                    1, // Update when multiple images available
                                effect: const ExpandingDotsEffect(
                                  activeDotColor: AppTheme.primaryColor,
                                  dotColor: Colors.white54,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Product Info
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppTheme.radiusXl),
                        ),
                      ),
                      transform: Matrix4.translationValues(0, -20, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingLg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Handle Bar
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppTheme.textHint.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusRound),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingLg),

                            // Category & Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingMd,
                                    vertical: AppTheme.spacingXs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceColor,
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusMd),
                                  ),
                                  child: Text(
                                    product.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: AppTheme.primaryColor,
                                        ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: AppTheme.warningColor, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${product.rating?.rate ?? 0} (${product.rating?.count ?? 0} reviews)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingMd),

                            // Title
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: AppTheme.spacingLg),

                            // Description
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppTheme.spacingSm),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDescriptionExpanded =
                                      !_isDescriptionExpanded;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                          height: 1.5,
                                        ),
                                    maxLines: _isDescriptionExpanded ? null : 3,
                                    overflow: _isDescriptionExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                                  ),
                                  if (!_isDescriptionExpanded)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Read More',
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingXxl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is ProductError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () {
                  context
                      .read<ProductBloc>()
                      .add(LoadProduct(widget.productId));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoaded) {
              final product = state.product.toEntity();
              return Container(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppTheme.radiusXl),
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
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
                      const SizedBox(width: AppTheme.spacingLg),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Add to Cart',
                          icon: Icons.shopping_cart_outlined,
                          onPressed: () {
                            // Add to cart logic
                            final cartItem = CartItemModel(
                              productId: product.id,
                              title: product.name,
                              price: product.price,
                              image: product.imageUrl,
                              quantity: 1,
                            );
                            context.read<CartCubit>().addToCart(cartItem);
                            _showAddedToCartDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddedToCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SuccessAnimationWidget(
                title: 'Added to Cart!',
                message: 'Item has been added to your cart successfully.',
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   child: SecondaryButton(
                  //     text: 'Keep Shopping',
                  //     onPressed: () => Navigator.pop(context),
                  //   ),
                  // ),
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Go to Cart',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDetailsShimmer extends StatelessWidget {
  const _ProductDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ShimmerBox(
            width: double.infinity,
            height: 400,
            borderRadius: 0,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppTheme.radiusXl),
                ),
              ),
              child: const SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppTheme.spacingLg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(
                          width: 100,
                          height: 24,
                          borderRadius: AppTheme.radiusMd,
                        ),
                        ShimmerBox(
                          width: 80,
                          height: 20,
                          borderRadius: AppTheme.radiusMd,
                        ),
                      ],
                    ),
                     SizedBox(height: AppTheme.spacingMd),
                     ShimmerBox(
                      width: double.infinity,
                      height: 32,
                    ),
                     SizedBox(height: AppTheme.spacingSm),
                     ShimmerBox(
                      width: 200,
                      height: 32,
                    ),
                     SizedBox(height: AppTheme.spacingLg),
                    ShimmerBox(
                      width: 100,
                      height: 24,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    const ShimmerBox(
                      width: double.infinity,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
