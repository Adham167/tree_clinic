import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/app/tree_clinic.dart';
import 'package:tree_clinic/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();

  runApp(const TreeClinic());
}
