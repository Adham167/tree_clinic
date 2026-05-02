
import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/chip_widget.dart';

class DiagnosisSummary extends StatelessWidget {
  const DiagnosisSummary({
    required this.disease,
    required this.crop,
    required this.confidencePercent,
    required this.status,
  });

  final String disease;
  final String crop;
  final double confidencePercent;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 76,
            width: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: confidencePercent / 100,
                  strokeWidth: 7,
                  backgroundColor: Colors.green.withValues(alpha: 0.12),
                  color: Colors.green,
                ),
                Text(
                  '${confidencePercent.toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disease.isEmpty ? context.tr('Unknown disease') : disease,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChipWidget(icon: Icons.grass, label: crop),
                    ChipWidget(icon: Icons.verified_outlined, label: status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
