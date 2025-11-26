import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'guards/auth_guard.dart';
import '../features/splash/splash_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/profile/pages/personal_information_page.dart';
import '../features/profile/pages/shipping_addresses_page.dart';
import '../features/profile/pages/notifications_settings_page.dart';
import '../features/home/home_page.dart';
import '../features/products/presentation/pages/product_details_page.dart';
import '../features/cart/presentation/pages/cart_page.dart';
import '../features/cart/presentation/pages/checkout_page.dart';
import '../features/orders/presentation/pages/orders_page.dart';
import '../features/auth/presentation/pages/email_verification_page.dart';
import '../features/wishlist/presentation/pages/wishlist_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: EmailVerificationRoute.page),
        AutoRoute(
          page: HomeRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: ProductDetailsRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: CartRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: CheckoutRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: OrdersRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: WishlistRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: ProfileRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: PersonalInformationRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: ShippingAddressesRoute.page,
          guards: [authGuard],
        ),
        AutoRoute(
          page: NotificationsSettingsRoute.page,
          guards: [authGuard],
        ),
      ];
}
