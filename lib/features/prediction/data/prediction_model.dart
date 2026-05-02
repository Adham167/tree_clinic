class PredictionModel {
  final double confidence;
  final String crop;
  final String disease;
  final String status;

  // Details
  final String name;
  final String scientificName;
  final String type;
  final String description;

  final List<String> cause;
  final List<String> prevention;

  // Irrigation
  final String diseaseBehavior;
  final List<String> bestPractices;
  final List<Map<String, dynamic>> recommendationsByCondition;

  // Treatment
  final List<String> applicationNotes;
  final List<String> chemical;
  final List<String> organic;

  PredictionModel({
    required this.confidence,
    required this.crop,
    required this.disease,
    required this.status,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.description,
    required this.cause,
    required this.prevention,
    required this.diseaseBehavior,
    required this.bestPractices,
    required this.recommendationsByCondition,
    required this.applicationNotes,
    required this.chemical,
    required this.organic,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    final details = (json['details'] as Map?) ?? const {};
    final irrigation = (details['irrigation'] as Map?) ?? const {};
    final treatment = (details['treatment'] as Map?) ?? const {};

    return PredictionModel(
      confidence: ((json['confidence'] ?? 0) as num).toDouble(),
      crop: json['crop'] ?? '',
      disease: json['disease'] ?? '',
      status: json['status'] ?? '',

      name: details['disease_name'] ?? '',
      scientificName: details['scientific_name'] ?? '',
      type: details['type'] ?? '',
      description: details['description'] ?? '',

      cause: _stringList(details['cause']),
      prevention: _stringList(details['prevention']),

      diseaseBehavior: irrigation['disease_behavior'] ?? '',
      bestPractices: _stringList(irrigation['best_practices']),
      recommendationsByCondition: List<Map<String, dynamic>>.from(
        irrigation['recommendations_by_condition'] ?? const [],
      ),

      applicationNotes: _stringList(treatment['application_notes']),
      chemical: _stringList(treatment['chemical']),
      organic: _stringList(treatment['organic']),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) => item.toString()).toList();
  }
}
