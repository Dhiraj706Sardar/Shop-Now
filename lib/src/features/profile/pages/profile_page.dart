import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';
import 'package:ecommerce_app/src/core/widgets/buttons.dart';
import 'package:ecommerce_app/src/router/app_router.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/src/features/auth/presentation/bloc/auth_state.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.settings_outlined),
        //     onPressed: () {
        //       // Settings
        //     },
        //   ),
        // ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            context.router.replaceAll([const AuthRoute()]);
          }
        },
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              user.email.isNotEmpty
                                  ? user.email[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          user.displayName ?? user.email.split('@')[0],
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          user.email,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXxl),

                  // Menu Items
                  _buildMenuSection(
                    context,
                    title: 'Account',
                    items: [
                      _MenuItem(
                        icon: Icons.person_outline,
                        title: 'Personal Information',
                        onTap: () => context.router
                            .push(const PersonalInformationRoute()),
                      ),
                      _MenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () => context.router.push(const OrdersRoute()),
                      ),
                      _MenuItem(
                        icon: Icons.favorite_border,
                        title: 'Wishlist',
                        onTap: () => context.router.push(const WishlistRoute()),
                      ),
                      _MenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Shipping Addresses',
                        onTap: () =>
                            context.router.push(const ShippingAddressesRoute()),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLg),

                  _buildMenuSection(
                    context,
                    title: 'Settings',
                    items: [
                      _MenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        onTap: () => context.router
                            .push(const NotificationsSettingsRoute()),
                      ),
                      _MenuItem(
                        icon: Icons.language,
                        title: 'Language',
                        trailing: 'English',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        isSwitch: true,
                        switchValue: true,
                        onSwitchChanged: (value) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXl),

                  // Logout Button
                  SecondaryButton(
                    text: 'Log Out',
                    icon: Icons.logout,
                    onPressed: () {
                      context.read<AuthBloc>().add(const SignOutRequested());
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppTheme.spacingSm),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: Column(
            children: items.map((item) {
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Icon(item.icon, size: 20),
                    ),
                    title: Text(item.title),
                    trailing: item.isSwitch
                        ? Switch(
                            value: item.switchValue,
                            onChanged: item.onSwitchChanged,
                            activeColor: AppTheme.primaryColor,
                          )
                        : item.trailing != null
                            ? Text(
                                item.trailing!,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : const Icon(Icons.chevron_right, size: 20),
                    onTap: item.isSwitch ? null : item.onTap,
                  ),
                  if (item != items.last)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: AppTheme.textHint.withOpacity(0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String? trailing;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });
}
