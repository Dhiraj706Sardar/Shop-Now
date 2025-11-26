import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';

class ShimmerWrapper extends StatelessWidget {
  const ShimmerWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceColor,
      highlightColor: AppTheme.surfaceColor.withValues(alpha: 0.5),
      child: child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppTheme.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            const ShimmerBox(
              width: double.infinity,
              height: 140,
              borderRadius: AppTheme.radiusLg,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const ShimmerBox(
                    width: double.infinity,
                    height: 16,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  // Subtitle
                  ShimmerBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 14,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  // Price and button row
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerBox(
                        width: 80,
                        height: 20,
                      ),
                      ShimmerBox(
                        width: 40,
                        height: 40,
                        borderRadius: AppTheme.radiusSm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
          ],
        ),
      ),
    );
  }
}

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key, this.itemCount = 6});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerWrapper(
      child: Column(
        children: [
          ShimmerBox(
            width: 70,
            height: 70,
            borderRadius: AppTheme.radiusRound,
          ),
          SizedBox(height: AppTheme.spacingSm),
          ShimmerBox(
            width: 60,
            height: 12,
          ),
        ],
      ),
    );
  }
}

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        itemCount: 6,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppTheme.spacingMd),
        itemBuilder: (context, index) => const CategoryShimmer(),
      ),
    );
  }
}

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Row(
          children: [
            // Image
            const ShimmerBox(
              width: 80,
              height: 80,
              borderRadius: AppTheme.radiusMd,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(
                    width: double.infinity,
                    height: 16,
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  ShimmerBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 14,
                  ),
                  const SizedBox(height: AppTheme.spacingMd),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerBox(
                        width: 60,
                        height: 18,
                      ),
                      ShimmerBox(
                        width: 100,
                        height: 32,
                        borderRadius: AppTheme.radiusSm,
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
  }
}

class CartListShimmer extends StatelessWidget {
  const CartListShimmer({super.key, this.itemCount = 3});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: itemCount,
      itemBuilder: (context, index) => const CartItemShimmer(),
    );
  }
}

class OrderCardShimmer extends StatelessWidget {
  const OrderCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(
                  width: 120,
                  height: 16,
                ),
                ShimmerBox(
                  width: 80,
                  height: 24,
                  borderRadius: AppTheme.radiusSm,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const ShimmerBox(
              width: double.infinity,
              height: 14,
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 14,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(
                  width: 100,
                  height: 18,
                ),
                ShimmerBox(
                  width: 80,
                  height: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderListShimmer extends StatelessWidget {
  const OrderListShimmer({super.key, this.itemCount = 4});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: itemCount,
      itemBuilder: (context, index) => const OrderCardShimmer(),
    );
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        child: const ShimmerBox(
          width: double.infinity,
          height: 180,
          borderRadius: AppTheme.radiusLg,
        ),
      ),
    );
  }
}
