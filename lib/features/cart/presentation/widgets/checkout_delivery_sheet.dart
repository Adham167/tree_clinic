import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/egypt_delivery_options.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/cart/data/model/delivery_details.dart';

class CheckoutDeliverySheet extends StatefulWidget {
  const CheckoutDeliverySheet({super.key, required this.initialDetails});

  final DeliveryDetails initialDetails;

  @override
  State<CheckoutDeliverySheet> createState() => _CheckoutDeliverySheetState();
}

class _CheckoutDeliverySheetState extends State<CheckoutDeliverySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  String? _selectedGovernorate;
  late String _placeType;
  String? _selectedPlaceAvailability;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.initialDetails.fullName,
    );
    _addressController = TextEditingController(
      text: widget.initialDetails.address,
    );
    _phoneController = TextEditingController(text: widget.initialDetails.phone);
    _selectedGovernorate =
        egyptGovernorates.contains(widget.initialDetails.governorate)
            ? widget.initialDetails.governorate
            : null;
    _placeType =
        widget.initialDetails.placeType.trim().isNotEmpty
            ? widget.initialDetails.placeType
            : 'House';
    _selectedPlaceAvailability =
        deliveryLocationTimeSlots.contains(
              widget.initialDetails.placeAvailability,
            )
            ? widget.initialDetails.placeAvailability
            : null;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      DeliveryDetails(
        fullName: _fullNameController.text.trim(),
        governorate: _selectedGovernorate?.trim() ?? '',
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        placeType: _placeType,
        availability: '',
        placeAvailability: _selectedPlaceAvailability?.trim() ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('Delivery Details'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.tr(
                      'Fill in your delivery information before checkout.',
                    ),
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    controller: _fullNameController,
                    label: context.tr('Recipient Name'),
                    validatorMessage: context.tr('Recipient name is required'),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGovernorate,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.tr('Governorate'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items:
                        egyptGovernorates
                            .map(
                              (governorate) => DropdownMenuItem(
                                value: governorate,
                                child: Text(context.tr(governorate)),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGovernorate = value;
                      });
                    },
                    validator: (value) {
                      if ((value?.trim().isEmpty ?? true)) {
                        return context.tr('Governorate is required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _addressController,
                    label: context.tr('Delivery Address'),
                    validatorMessage: context.tr(
                      'Delivery address is required',
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _phoneController,
                    label: context.tr('Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) {
                        return context.tr('Phone is required');
                      }
                      if (trimmed.length < 8) {
                        return context.tr('Enter a valid phone number');
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _placeType,
                    decoration: InputDecoration(
                      labelText: context.tr('Place Type'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'House',
                        child: Text(context.tr('House')),
                      ),
                      DropdownMenuItem(
                        value: 'Workplace',
                        child: Text(context.tr('Workplace')),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _placeType = value ?? 'House';
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedPlaceAvailability,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.tr('Location availability'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items:
                        deliveryLocationTimeSlots
                            .map(
                              (slot) => DropdownMenuItem(
                                value: slot,
                                child: Text(context.tr(slot)),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPlaceAvailability = value;
                      });
                    },
                    validator: (value) {
                      if ((value?.trim().isEmpty ?? true)) {
                        return context.tr('Location availability is required');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(context.tr('Submit Order')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? validatorMessage,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator:
          validator ??
          (value) {
            if ((value?.trim().isEmpty ?? true) && validatorMessage != null) {
              return validatorMessage;
            }
            return null;
          },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
