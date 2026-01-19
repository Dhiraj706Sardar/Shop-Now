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
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

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

  // PayPal Configuration
  static const String _paypalClientId = "YOUR_PAYPAL_CLIENT_ID";
  static const String _paypalSecretKey = "YOUR_PAYPAL_SECRET_KEY";
  static const bool _sandboxMode = true;

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
        // Check if PayPal is selected
        if (_selectedPaymentMethod == 1) {
          _launchPayPalCheckout(cartState, authState.user.id);
        } else {
          // For other payment methods, create order directly
          _createOrder(cartState, authState.user.id);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to place order')),
        );
      }
    }
  }

  void _createOrder(CartLoaded cartState, String userId) {
    final order = OrderModel(
      userId: userId,
      items: cartState.items,
      total: cartState.total,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    context.read<OrderBloc>().add(CreateOrder(order));
  }

  void _launchPayPalCheckout(CartLoaded cartState, String userId) {
    final total = cartState.total * 1.1 + 10.00; // Including tax and shipping
    final subtotal = cartState.total;
    final shipping = 10.00;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: _sandboxMode,
          clientId: _paypalClientId,
          secretKey: _paypalSecretKey,
          transactions: [
            {
              "amount": {
                "total": total.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": subtotal.toStringAsFixed(2),
                  "shipping": shipping.toStringAsFixed(2),
                  "shipping_discount": 0
                }
              },
              "description":
                  "Order payment for ${cartState.items.length} items",
              "item_list": {
                "items": _buildPayPalItems(cartState.items),
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            print("PayPal Payment Success: $params");
            // Create order after successful payment
            _createOrder(cartState, userId);
            Navigator.pop(context);
          },
          onError: (error) {
            print("PayPal Payment Error: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment failed: $error'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
            Navigator.pop(context);
          },
          onCancel: () {
            print('PayPal Payment Cancelled');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment cancelled'),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _buildPayPalItems(List<dynamic> cartItems) {
    return cartItems.map((item) {
      // Assuming item has the structure from CartItemModel
      return {
        "name": item.title ?? 'Product',
        "quantity": item.quantity ?? 1,
        "price": (item.price ?? 0.0).toStringAsFixed(2),
        "currency": "USD"
      };
    }).toList();
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
                  lottieAsset: 'assets/lottie/payment.json',
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
