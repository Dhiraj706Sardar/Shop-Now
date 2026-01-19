import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/lottie_widgets.dart';
import '../../../../router/app_router.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Discover Latest Trends',
      description:
          'Explore the newest fashion trends and styles curated just for you.',
      lottieAsset: 'assets/lottie/shopping_bag.json',
    ),
    OnboardingItem(
      title: 'Easy Secure Payments',
      description: 'Pay safely and securely with our multiple payment options.',
      lottieAsset: 'assets/lottie/payment.json',
    ),
    OnboardingItem(
      title: 'Fast Delivery',
      description: 'Get your orders delivered to your doorstep in record time.',
      lottieAsset: 'assets/lottie/delivery.json',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      context.router.replace(const AuthRoute());
    }
  }

  void _onNext() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingXl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animation
                        Expanded(
                          flex: 3,
                          child: LottieAnimationWidget(
                            assetPath: item.lottieAsset,
                            width: 300,
                            height: 300,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXl),

                        // Text Content
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.displaySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppTheme.spacingMd),
                              Text(
                                item.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _items.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppTheme.primaryColor,
                      dotColor: AppTheme.surfaceColor,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),

                  // Next/Get Started Button
                  PrimaryButton(
                    text: _currentPage == _items.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _onNext,
                    isFullWidth: false,
                    width: 140,
                    icon: Icons.arrow_forward,
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

class OnboardingItem {
  final String title;
  final String description;
  final String lottieAsset;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.lottieAsset,
  });
}
