import 'package:get/get.dart';

class LabReportAnalysisController extends GetxController {
  final String reportId;

  LabReportAnalysisController({required this.reportId});

  @override
  void onInit() {
    super.onInit();
    // later: fetch API with this.reportId
    print("Fetching lab report for ID: $reportId");
  }

  // Dummy Data for now
  final healthScore = 78.obs;
  final summaryText =
      "Your cholesterol levels are slightly elevated and require attention. "
              "Your blood sugar is within normal range, showing good metabolic health. "
              "Liver function appears healthy with all enzymes in optimal ranges. "
              "Kidney function shows excellent filtration rates."
          .obs;

  // Detailed Analysis
  final detailedAnalysis = [
    {
      "title": "Total Cholesterol",
      "condition": "Lipid Panel",
      "value": "245 mg/dL",
      "note": "Borderline High",
    },
    {
      "title": "LDL Cholesterol",
      "condition": "Bad Cholesterol",
      "value": "170 mg/dL",
      "note": "Bad Cholesterol",
    },
  ].obs;

  // Health Trends
  final healthTrends = [
    {
      "title": "Cholesterol",
      "status": "Increasing",
      "note": "15 mg/dL from last test",
    },
    {
      "title": "Blood Sugar",
      "status": "Stable",
      "note": "Stable over 6 months",
    },
    {
      "title": "HDL Cholesterol",
      "status": "Improving",
      "note": "5mg/dL Improvement",
    },
  ].obs;

  // Recommendations
  final recommendations = [
    "Add 25g fiber daily.",
    "Reduce saturated fats.",
    "Include omega-3 sources.",
  ].obs;

  // Risk Assessment
  final riskAssessment = [
    {
      "title": "Cardiovascular Risk",
      "description":
          "Elevated cholesterol increases your risk of heart disease. Immediate lifestyle changes recommended.",
      "level": "Moderate",
      "icon": "❤️",
    },
    {
      "title": "Diabetes Risk",
      "description":
          "Elevated cholesterol increases your risk of diabetes. Immediate lifestyle changes recommended.",
      "level": "Low",
      "icon": "🩸",
    },
  ].obs;

 


}
