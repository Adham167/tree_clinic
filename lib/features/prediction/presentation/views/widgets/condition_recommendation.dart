
import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/bullet_text.dart';

class ConditionRecommendation extends StatelessWidget {
  const ConditionRecommendation({required this.item});

  final Map<String, dynamic> item;

  String _localized(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return context.tr(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = item['recommendations'];
    final recommendationItems =
        recommendations is List
            ? recommendations.map((value) => value.toString()).toList()
            : <String>[];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.tr(item['condition']?.toString() ?? 'Condition')} - ${context.tr('Risk')}: ${_localized(context, item['risk_level']?.toString() ?? 'N/A')}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...recommendationItems.map(
            (text) => BulletText(_localized(context, text)),
          ),
        ],
      ),
    );
  }
}
