import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/bullet_text.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/detail_row.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/diagnosis_summary.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/image_header.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/info_section.dart';
import 'package:tree_clinic/features/prediction/presentation/views/widgets/recommendations_section.dart';
import 'package:tree_clinic/features/shopping/presentation/views/shop_page.dart';

class PredictResultPage extends StatelessWidget {
  const PredictResultPage({
    super.key,
    required this.predictionModel,
    required this.imagePath,
  });

  final PredictionModel predictionModel;
  final String imagePath;

  String _localized(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return context.tr(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (predictionModel.confidence * 100).clamp(0, 100);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F3),
      appBar: AppBar(
        title: Text(context.tr('Prediction Result')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ImageHeader(imagePath: imagePath),
          const SizedBox(height: 16),

          DiagnosisSummary(
            disease: _localized(context, predictionModel.disease),
            crop: _localized(context, predictionModel.crop),
            confidencePercent: confidencePercent.toDouble(),
            status: _localized(context, predictionModel.status),
          ),

          const SizedBox(height: 16),

          InfoSection(
            title: context.tr('Disease Overview'),
            icon: Icons.info_outline,
            children: [
              DetailRow(
                label: context.tr('Name'),
                value: _localized(context, predictionModel.name),
              ),
              DetailRow(
                label: context.tr('Scientific'),
                value: predictionModel.scientificName,
              ),
              DetailRow(
                label: context.tr('Type'),
                value: _localized(context, predictionModel.type),
              ),
              const SizedBox(height: 8),
              Text(
                predictionModel.description.isEmpty
                    ? context.tr(
                      'No description is available for this diagnosis.',
                    )
                    : _localized(context, predictionModel.description),
                style: TextStyle(
                  color: Colors.grey.shade800,
                  height: 1.45,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          InfoSection(
            title: context.tr('Likely Causes'),
            icon: Icons.search,
            children: _buildBulletList(context, predictionModel.cause),
          ),

          const SizedBox(height: 16),

          RecommendationsSection(predictionModel: predictionModel),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              final meds = [
                ...predictionModel.chemical,
                ...predictionModel.organic,
              ];

              final cleaned =
                  meds.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

              final searchQuery = cleaned.take(3).join(" ");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShopPage(initialSearch: searchQuery),
                ),
              );
            },
            icon: const Icon(Icons.shopping_bag),
            label: Text(context.tr("Search treatments in shop")),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBulletList(BuildContext context, List<String> items) {
    if (items.isEmpty) {
      return [Text(context.tr('No items available.'))];
    }

    return items.map((item) => BulletText(_localized(context, item))).toList();
  }
}
