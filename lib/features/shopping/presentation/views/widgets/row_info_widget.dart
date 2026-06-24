import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';

class RowInfoWidget extends StatelessWidget {
  const RowInfoWidget({
    super.key,
    required this.value,
    required this.kkey,
  });

  final String value;
  final String kkey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr(kkey),
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Text(
            context.tr(value),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
} 