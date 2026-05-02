import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';

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
          _ImageHeader(imagePath: imagePath),
          const SizedBox(height: 16),
          _DiagnosisSummary(
            disease: _localized(context, predictionModel.disease),
            crop: _localized(context, predictionModel.crop),
            confidencePercent: confidencePercent.toDouble(),
            status: _localized(context, predictionModel.status),
          ),
          const SizedBox(height: 16),
          _InfoSection(
            title: context.tr('Disease Overview'),
            icon: Icons.info_outline,
            children: [
              _DetailRow(
                label: context.tr('Name'),
                value: _localized(context, predictionModel.name),
              ),
              _DetailRow(
                label: context.tr('Scientific'),
                value: predictionModel.scientificName,
              ),
              _DetailRow(
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
          _InfoSection(
            title: context.tr('Likely Causes'),
            icon: Icons.search,
            children: _buildBulletList(context, predictionModel.cause),
          ),
          const SizedBox(height: 16),
          _RecommendationsSection(predictionModel: predictionModel),
        ],
      ),
    );
  }

  List<Widget> _buildBulletList(BuildContext context, List<String> items) {
    if (items.isEmpty) {
      return [Text(context.tr('No items available.'))];
    }

    return items
        .map((item) => _BulletText(_localized(context, item)))
        .toList();
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (file.existsSync())
              Image.file(file, fit: BoxFit.cover)
            else
              Container(
                color: Colors.green.withValues(alpha: 0.08),
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 56),
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.tr('Uploaded leaf image'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagnosisSummary extends StatelessWidget {
  const _DiagnosisSummary({
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
                    _Chip(icon: Icons.grass, label: crop),
                    _Chip(icon: Icons.verified_outlined, label: status),
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

class _RecommendationsSection extends StatelessWidget {
  const _RecommendationsSection({required this.predictionModel});

  final PredictionModel predictionModel;

  String _localized(BuildContext context, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return context.tr(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return _InfoSection(
      title: context.tr('Recommendations'),
      icon: Icons.checklist,
      children: [
        _RecommendationTile(
          title: context.tr('Prevention'),
          icon: Icons.shield_outlined,
          children: _bulletWidgets(context, predictionModel.prevention),
        ),
        _RecommendationTile(
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
              (item) => _ConditionRecommendation(item: item),
            ),
          ],
        ),
        _RecommendationTile(
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
        .map((item) => _BulletText(_localized(context, item)))
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

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: Icon(icon, color: Colors.green),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          children: children,
        ),
      ),
    );
  }
}

class _ConditionRecommendation extends StatelessWidget {
  const _ConditionRecommendation({required this.item});

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
            (text) => _BulletText(_localized(context, text)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.green),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (label.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
