import 'package:auto_route/auto_route.dart';
import 'package:ecommerce_app/src/router/app_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class AuthGuard extends AutoRouteGuard {
  final SupabaseClient _supabaseClient;

  AuthGuard(this._supabaseClient);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final user = _supabaseClient.auth.currentUser;

    if (user != null) {
      resolver.next(true);
    } else {
      resolver.redirect(const AuthRoute());
    }
  }
}
