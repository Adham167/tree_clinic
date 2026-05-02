
import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/bullet_text.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/condition_recommendation.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/info_section.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/recommendation_tile.dart';

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({required this.predictionModel});

  final PredictionModel predictionModel;

  String _localized(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return context.tr(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return InfoSection(
      title: context.tr('Recommendations'),
      icon: Icons.checklist,
      children: [
        RecommendationTile(
          title: context.tr('Prevention'),
          icon: Icons.shield_outlined,
          children: _bulletWidgets(context, predictionModel.prevention),
        ),
        RecommendationTile(
          title: context.tr('Irrigation'),
          icon: Icons.water_drop_outlined,
          children: [
            if (predictionModel.diseaseBehavior.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _localized(context, predictionModel.diseaseBehavior),
                  style: const TextStyle(height: 1.4),
                ),
              ),
            ..._bulletWidgets(context, predictionModel.bestPractices),
            ...predictionModel.recommendationsByCondition.map(
              (item) => ConditionRecommendation(item: item),
            ),
          ],
        ),
        RecommendationTile(
          title: context.tr('Treatment'),
          icon: Icons.healing_outlined,
          children: [
            ..._subsection(
              context,
              context.tr('Application notes'),
              predictionModel.applicationNotes,
            ),
            ..._subsection(
              context,
              context.tr('Chemical treatment'),
              predictionModel.chemical,
            ),
            ..._subsection(
              context,
              context.tr('Organic treatment'),
              predictionModel.organic,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _bulletWidgets(BuildContext context, List<String> items) {
    if (items.isEmpty) {
      return [Text(context.tr('No recommendations available.'))];
    }
    return items
        .map((item) => BulletText(_localized(context, item)))
        .toList();
  }

  List<Widget> _subsection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    if (items.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      ..._bulletWidgets(context, items),
    ];
  }
}
