import 'package:flutter/material.dart';
import 'package:tree_clinic/features/prediction/data/prediction_model.dart';

class PredictResultPage extends StatelessWidget {
  const PredictResultPage({super.key, required this.predictionModel,});
  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Result"),
        backgroundColor: Colors.green,
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic info card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      predictionModel.disease,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    SizedBox(height: 8),
                    Text("Crop: ${predictionModel.crop}"),
                    Text("Confidence: ${(predictionModel.confidence * 100).toStringAsFixed(1)}%"),
                    Text("Status: ${predictionModel.status}"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Details section
            _sectionTitle("Details"),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${predictionModel.name}", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Scientific Name: ${predictionModel.scientificName}"),
                    SizedBox(height: 4),
                    Text("Type: ${predictionModel.type}"),
                    SizedBox(height: 4),
                    Text("Cause: ${predictionModel.cause}"),
                    SizedBox(height: 4),
                    Text("Description: ${predictionModel.description}"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Prevention
            _sectionTitle("Prevention"),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: predictionModel.prevention.map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("• "), Expanded(child: Text(item))]),
                  )).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Irrigation
            _sectionTitle("Irrigation"),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Disease Behavior: ${predictionModel.diseaseBehavior}"),
                    SizedBox(height: 8),
                    Text("Best Practices:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...predictionModel.bestPractices.map((item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text("• $item"),
                    )),
                    SizedBox(height: 8),
                    Text("Temperature Based:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...predictionModel.temperatureBased.map((tempMap) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text("• ${tempMap['condition']}: ${tempMap['action']}"),
                    )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Treatment
            _sectionTitle("Treatment"),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Application Notes: ${predictionModel.applicationNotes}"),
                    SizedBox(height: 8),
                    Text("Chemical Treatments:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...predictionModel.chemical.map((item) => Text("• $item")),
                    SizedBox(height: 8),
                    Text("Organic Treatments:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...predictionModel.organic.map((item) => Text("• $item")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade800),
      ),
    );
  }
}