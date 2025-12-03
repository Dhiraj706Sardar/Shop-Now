import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/text_fields.dart';
import '../../../../core/widgets/lottie_widgets.dart';
import '../../../../router/app_router.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

@RoutePage()
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  int _selectedPaymentMethod = 0;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _onPlaceOrder(CartLoaded cartState) {
    if (_formKey.currentState?.validate() ?? false) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final order = OrderModel(
          userId: authState.user.id,
          items: cartState.items,
          total: cartState.total,
          status: OrderStatus.pending,
          createdAt: DateTime.now(),
        );
        context.read<OrderBloc>().add(CreateOrder(order));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to place order')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderCreated) {
          context.read<CartCubit>().clearCart();
          _showSuccessDialog(context);
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState is CartLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shipping Address
                      Text(
                        'Shipping Address',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      CustomTextField(
                        label: 'Address',
                        hint: 'Enter your street address',
                        controller: _addressController,
                        prefixIcon: Icons.home_outlined,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'City',
                              hint: 'Enter city',
                              controller: _cityController,
                              prefixIcon: Icons.location_city,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(
                            child: CustomTextField(
                              label: 'ZIP Code',
                              hint: '12345',
                              controller: _zipController,
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.pin_drop_outlined,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXl),

                      // Payment Method
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      _buildPaymentOption(
                        index: 0,
                        title: 'Credit Card',
                        icon: Icons.credit_card,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      _buildPaymentOption(
                        index: 1,
                        title: 'PayPal',
                        icon: Icons.payment,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      _buildPaymentOption(
                        index: 2,
                        title: 'Cash on Delivery',
                        icon: Icons.money,
                      ),
                      const SizedBox(height: AppTheme.spacingXl),

                      // Order Summary
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMd),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusLg),
                          border: Border.all(
                            color: AppTheme.textHint.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow('Subtotal', cartState.total),
                            const SizedBox(height: AppTheme.spacingSm),
                            _buildSummaryRow('Shipping', 10.00),
                            const SizedBox(height: AppTheme.spacingSm),
                            _buildSummaryRow('Tax', cartState.total * 0.1),
                            const Divider(height: AppTheme.spacingXl),
                            _buildSummaryRow(
                              'Total',
                              cartState.total * 1.1 + 10.00,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXl),

                      // Place Order Button
                      BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, orderState) {
                          return PrimaryButton(
                            text: 'Place Order',
                            onPressed: () => _onPlaceOrder(cartState),
                            isLoading: orderState is OrderLoading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
              : const TextStyle(color: AppTheme.textSecondary),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: isTotal
              ? const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.primaryColor,
                )
              : const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SuccessAnimationWidget(
                  title: 'Order Placed!',
                  message: 'Your order has been placed successfully.',
                  onComplete: () {
                    // Optional: auto navigate
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
                PrimaryButton(
                  text: 'Continue Shopping',
                  onPressed: () {
                    context.router.replaceAll([const HomeRoute()]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
