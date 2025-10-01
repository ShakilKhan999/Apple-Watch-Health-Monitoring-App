import 'package:flutter/material.dart';
import 'package:surajashray/app.dart';
import 'package:surajashray/core/localization/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization service
  await LocalizationService.init();

  runApp(const Surajashray());
}
