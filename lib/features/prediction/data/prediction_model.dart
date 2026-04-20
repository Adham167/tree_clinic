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
    final details = json['details'];
    final irrigation = details['irrigation'];
    final treatment = details['treatment'];

    return PredictionModel(
      confidence: json['confidence'],
      crop: json['crop'],
      disease: json['disease'],
      status: json['status'],

      name: details['disease_name'],
      scientificName: details['scientific_name'],
      type: details['type'],
      description: details['description'],

      cause: List<String>.from(details['cause']),
      prevention: List<String>.from(details['prevention']),

      diseaseBehavior: irrigation['disease_behavior'],
      bestPractices: List<String>.from(irrigation['best_practices']),
      recommendationsByCondition:
          List<Map<String, dynamic>>.from(
        irrigation['recommendations_by_condition'],
      ),

      applicationNotes:
          List<String>.from(treatment['application_notes']),
      chemical: List<String>.from(treatment['chemical']),
      organic: List<String>.from(treatment['organic']),
    );
  }
}