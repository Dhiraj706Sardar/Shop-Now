import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ecommerce_app/src/core/theme/app_theme.dart';
import 'package:ecommerce_app/src/core/widgets/buttons.dart';

@RoutePage()
class ShippingAddressesPage extends StatefulWidget {
  const ShippingAddressesPage({super.key});

  @override
  State<ShippingAddressesPage> createState() => _ShippingAddressesPageState();
}

class _ShippingAddressesPageState extends State<ShippingAddressesPage> {
  final List<ShippingAddress> _addresses = [
    ShippingAddress(
      id: '1',
      name: 'Home',
      fullAddress: '123 Main Street, Apartment 4B',
      city: 'New York',
      state: 'NY',
      zipCode: '10001',
      country: 'United States',
      phone: '+1 234 567 8900',
      isDefault: true,
    ),
    ShippingAddress(
      id: '2',
      name: 'Office',
      fullAddress: '456 Business Ave, Suite 200',
      city: 'San Francisco',
      state: 'CA',
      zipCode: '94102',
      country: 'United States',
      phone: '+1 234 567 8901',
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      return _buildAddressCard(_addresses[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: PrimaryButton(
              text: 'Add New Address',
              icon: Icons.add,
              onPressed: () => _showAddAddressDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingXl),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text(
            'No Addresses Yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Add a shipping address to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddress address) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: address.isDefault
            ? Border.all(color: AppTheme.primaryColor, width: 2)
            : null,
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(AppTheme.spacingMd),
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                gradient: address.isDefault
                    ? AppTheme.primaryGradient
                    : AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(
                address.name.toLowerCase() == 'home'
                    ? Icons.home_outlined
                    : Icons.business_outlined,
                color: Colors.white,
              ),
            ),
            title: Row(
              children: [
                Text(
                  address.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: AppTheme.spacingSm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingSm),
                Text(address.fullAddress),
                Text('${address.city}, ${address.state} ${address.zipCode}'),
                Text(address.country),
                const SizedBox(height: AppTheme.spacingXs),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: AppTheme.spacingXs),
                    Text(
                      address.phone,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    _showEditAddressDialog(address);
                    break;
                  case 'delete':
                    _deleteAddress(address);
                    break;
                  case 'default':
                    _setDefaultAddress(address);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 20),
                      SizedBox(width: AppTheme.spacingSm),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (!address.isDefault)
                  const PopupMenuItem(
                    value: 'default',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 20),
                        SizedBox(width: AppTheme.spacingSm),
                        Text('Set as Default'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 20, color: AppTheme.errorColor),
                      SizedBox(width: AppTheme.spacingSm),
                      Text('Delete',
                          style: TextStyle(color: AppTheme.errorColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog() {
    _showAddressFormDialog();
  }

  void _showEditAddressDialog(ShippingAddress address) {
    _showAddressFormDialog(address: address);
  }

  void _showAddressFormDialog({ShippingAddress? address}) {
    final nameController = TextEditingController(text: address?.name ?? '');
    final addressController =
        TextEditingController(text: address?.fullAddress ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final zipController = TextEditingController(text: address?.zipCode ?? '');
    final countryController =
        TextEditingController(text: address?.country ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(address == null ? 'Add Address' : 'Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Address Name',
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.public_outlined),
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement save functionality
              setState(() {
                if (address == null) {
                  _addresses.add(
                    ShippingAddress(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      fullAddress: addressController.text,
                      city: cityController.text,
                      state: stateController.text,
                      zipCode: zipController.text,
                      country: countryController.text,
                      phone: phoneController.text,
                      isDefault: _addresses.isEmpty,
                    ),
                  );
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(address == null
                      ? 'Address added successfully!'
                      : 'Address updated successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteAddress(ShippingAddress address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () {
              setState(() {
                _addresses.remove(address);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted successfully!'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(ShippingAddress address) {
    setState(() {
      for (var addr in _addresses) {
        addr.isDefault = addr.id == address.id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default address updated!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}

class ShippingAddress {
  final String id;
  final String name;
  final String fullAddress;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String phone;
  bool isDefault;

  ShippingAddress({
    required this.id,
    required this.name,
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });
}
