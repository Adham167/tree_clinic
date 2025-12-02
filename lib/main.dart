import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/app/custom_bloc_observer.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/app/tree_clinic.dart';
import 'package:tree_clinic/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  Bloc.observer = CustomBlocObserver();

  runApp(const TreeClinic());
}
