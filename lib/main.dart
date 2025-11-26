import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/core/di/injection.dart';
import 'package:ecommerce_app/src/router/app_router.dart';
import 'package:ecommerce_app/src/router/guards/auth_guard.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/src/core/utils/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  // Initialize dependency injection
  await configureDependencies();

  // Create router instance with AuthGuard
  final appRouter = AppRouter(authGuard: getIt<AuthGuard>());

  runApp(App(appRouter: appRouter));
}
