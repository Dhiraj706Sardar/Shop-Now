import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_theme.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final bool repeat;
  final bool reverse;
  final AnimationController? controller;

  const LottieAnimationWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.repeat = true,
    this.reverse = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to a simple animated icon if Lottie file is not found
        return Icon(
          Icons.shop_2_sharp,
          size: width ?? height ?? 100,
          color: AppTheme.primaryColor,
        );
      },
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? lottieAsset;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.lottieAsset,
    this.icon,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation or Icon
            if (lottieAsset != null)
              LottieAnimationWidget(
                assetPath: lottieAsset!,
                width: 200,
                height: 200,
              )
            else if (icon != null)
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            const SizedBox(height: AppTheme.spacingXl),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            // Button
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppTheme.spacingXl),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  child: Text(buttonText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onShopNow;

  const EmptyCartWidget({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Your Cart is Empty',
      message: 'Looks like you haven\'t added anything to your cart yet.',
      icon: Icons.shopping_cart_outlined,
      buttonText: 'Start Shopping',
      onButtonPressed: onShopNow,
    );
  }
}

class EmptyWishlistWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const EmptyWishlistWidget({super.key, this.onBrowseProducts});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Favorites Yet',
      message: 'Save your favorite items here for easy access later.',
      icon: Icons.favorite_border,
      buttonText: 'Browse Products',
      onButtonPressed: onBrowseProducts,
    );
  }
}

class EmptyOrdersWidget extends StatelessWidget {
  final VoidCallback? onStartShopping;

  const EmptyOrdersWidget({super.key, this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Orders Yet',
      message:
          'You haven\'t placed any orders yet. Start shopping to see your orders here.',
      icon: Icons.receipt_long_outlined,
      buttonText: 'Start Shopping',
      onButtonPressed: onStartShopping,
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.title = 'Oops! Something went wrong',
    this.message = 'We encountered an error. Please try again.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.errorColor, Color(0xFFFF8787)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXl),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingXl),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SuccessAnimationWidget extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onComplete;
  final Duration displayDuration;
  final String? lottieAsset;

  const SuccessAnimationWidget({
    super.key,
    required this.title,
    required this.message,
    this.onComplete,
    this.displayDuration = const Duration(seconds: 3),
    this.lottieAsset,
  });

  @override
  State<SuccessAnimationWidget> createState() => _SuccessAnimationWidgetState();
}

class _SuccessAnimationWidgetState extends State<SuccessAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Auto-complete after duration
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.lottieAsset != null)
              LottieAnimationWidget(
                assetPath: widget.lottieAsset!,
                width: 200,
                height: 200,
                repeat: false,
              )
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.successColor, Color(0xFF69F0AE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.successColor.withOpacity(0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            const SizedBox(height: AppTheme.spacingXl),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
