import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/src/core/di/injection.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/src/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecommerce_app/src/features/orders/presentation/bloc/order_bloc.dart';
import 'package:ecommerce_app/src/features/products/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:ecommerce_app/src/router/app_router.dart';

class App extends StatelessWidget {
  final AppRouter appRouter;

  const App({required this.appRouter, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<ProductBloc>()),
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<OrderBloc>()),
        BlocProvider(create: (_) => getIt<WishlistCubit>()),
      ],
      child: MaterialApp.router(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
