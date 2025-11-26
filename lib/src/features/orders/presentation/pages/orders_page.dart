import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../../../core/widgets/lottie_widgets.dart';
import '../../../../router/app_router.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../../data/models/order_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<OrderBloc>().add(LoadOrders(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const OrderListShimmer();
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return EmptyOrdersWidget(
                onStartShopping: () =>
                    context.router.replaceAll([const HomeRoute()]),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              itemCount: state.orders.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.spacingMd),
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _buildOrderCard(context, order);
              },
            );
          } else if (state is OrderError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () {
                final authState = context.read<AuthBloc>().state;
                if (authState is Authenticated) {
                  context.read<OrderBloc>().add(LoadOrders(authState.user.id));
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id?.substring(0, 8) ?? "..."}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(),
          const SizedBox(height: AppTheme.spacingMd),

          // Items Summary
          Text(
            '${order.items.length} Items',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Date and Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.createdAt != null
                    ? DateFormat('MMM dd, yyyy').format(order.createdAt!)
                    : 'Unknown Date',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = AppTheme.warningColor;
        text = 'Pending';
        break;
      case OrderStatus.processing:
        color = Colors.blue;
        text = 'Processing';
        break;
      case OrderStatus.shipped:
        color = Colors.purple;
        text = 'Shipped';
        break;
      case OrderStatus.delivered:
        color = AppTheme.successColor;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = AppTheme.errorColor;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
