import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(context.tr(label)),
      backgroundColor: Colors.green.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(color: Colors.green.withOpacity(0.3)),
    );
  }
}