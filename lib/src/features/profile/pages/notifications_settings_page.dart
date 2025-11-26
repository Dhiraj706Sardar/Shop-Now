import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/theme/app_theme.dart';

@RoutePage()
class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newArrivals = false;
  bool _priceDrops = true;
  bool _wishlistUpdates = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stay Updated',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your notification preferences',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXl),

          // Notification Types
          _buildSection(
            title: 'Notification Types',
            items: [
              _NotificationItem(
                icon: Icons.shopping_bag_outlined,
                title: 'Order Updates',
                subtitle: 'Get notified about order status changes',
                value: _orderUpdates,
                onChanged: (value) => setState(() => _orderUpdates = value),
              ),
              _NotificationItem(
                icon: Icons.local_offer_outlined,
                title: 'Promotions & Offers',
                subtitle: 'Receive exclusive deals and discounts',
                value: _promotions,
                onChanged: (value) => setState(() => _promotions = value),
              ),
              _NotificationItem(
                icon: Icons.new_releases_outlined,
                title: 'New Arrivals',
                subtitle: 'Be the first to know about new products',
                value: _newArrivals,
                onChanged: (value) => setState(() => _newArrivals = value),
              ),
              _NotificationItem(
                icon: Icons.trending_down_outlined,
                title: 'Price Drops',
                subtitle: 'Get alerts when prices drop on items',
                value: _priceDrops,
                onChanged: (value) => setState(() => _priceDrops = value),
              ),
              _NotificationItem(
                icon: Icons.favorite_border,
                title: 'Wishlist Updates',
                subtitle: 'Notifications about wishlist items',
                value: _wishlistUpdates,
                onChanged: (value) => setState(() => _wishlistUpdates = value),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXl),

          // Notification Channels
          _buildSection(
            title: 'Notification Channels',
            items: [
              _NotificationItem(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) =>
                    setState(() => _emailNotifications = value),
              ),
              _NotificationItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive push notifications on your device',
                value: _pushNotifications,
                onChanged: (value) =>
                    setState(() => _pushNotifications = value),
              ),
              _NotificationItem(
                icon: Icons.sms_outlined,
                title: 'SMS Notifications',
                subtitle: 'Receive notifications via SMS',
                value: _smsNotifications,
                onChanged: (value) => setState(() => _smsNotifications = value),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXl),

          // Info Card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  child: Text(
                    'You can change these settings anytime from your profile',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_NotificationItem> items,
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
                  _buildNotificationTile(item),
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

  Widget _buildNotificationTile(_NotificationItem item) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: item.value ? AppTheme.primaryGradient : null,
          color: item.value ? null : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        ),
        child: Icon(
          item.icon,
          size: 20,
          color: item.value ? Colors.white : AppTheme.textSecondary,
        ),
      ),
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        item.subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      value: item.value,
      onChanged: item.onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}
