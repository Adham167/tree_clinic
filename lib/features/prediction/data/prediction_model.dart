class PredictionModel {
  final double confidence;
  final String crop;
  final String disease;
  final String status;

  // Details
  final String cause;
  final String description;
  final String name;
  final String scientificName;
  final String type;

  final List<String> prevention;

  // Irrigation
  final List<String> bestPractices;
  final String diseaseBehavior;
  final List<Map<String, dynamic>> temperatureBased;

  // Treatment
  final String applicationNotes;
  final List<String> chemical;
  final List<String> organic;

  PredictionModel({
    required this.confidence,
    required this.crop,
    required this.disease,
    required this.status,
    required this.cause,
    required this.description,
    required this.name,
    required this.scientificName,
    required this.type,
    required this.prevention,
    required this.bestPractices,
    required this.diseaseBehavior,
    required this.temperatureBased,
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

      cause: details['cause'],
      description: details['description'],
      name: details['name'],
      scientificName: details['scientific_name'],
      type: details['type'],
      prevention: List<String>.from(details['prevention']),

      bestPractices: List<String>.from(irrigation['best_practices']),
      diseaseBehavior: irrigation['disease_behavior'],
      temperatureBased: List<Map<String, dynamic>>.from(
        irrigation['temperature_based'],
      ),

      applicationNotes: treatment['application_notes'],
      chemical: List<String>.from(treatment['chemical']),
      organic: List<String>.from(treatment['organic']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "confidence": confidence,
      "crop": crop,
      "disease": disease,
      "status": status,
      "details": {
        "cause": cause,
        "description": description,
        "name": name,
        "scientific_name": scientificName,
        "type": type,
        "prevention": prevention,
        "irrigation": {
          "best_practices": bestPractices,
          "disease_behavior": diseaseBehavior,
          "temperature_based": temperatureBased,
        },
        "treatment": {
          "application_notes": applicationNotes,
          "chemical": chemical,
          "organic": organic,
        },
      },
    };
  }
}
