import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_clinic/core/constants/google_auth_config.dart';
import 'package:tree_clinic/app/custom_bloc_observer.dart';
import 'package:tree_clinic/app/di/service_locator.dart';
import 'package:tree_clinic/app/tree_clinic.dart';
import 'package:tree_clinic/firebase_options.dart';
import 'package:tree_clinic/features/profile/presentation/manager/app_locale_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  try {
    await GoogleSignIn.instance.initialize(
      serverClientId: GoogleAuthConfig.serverClientId,
    );
  } catch (error) {
    debugPrint('Google Sign-In initialization failed: $error');
  }

  await initializeDependencies();
  final preferences = await SharedPreferences.getInstance();
  final initialLocale = AppLocaleCubit.resolveInitialLocale(preferences);

  Bloc.observer = CustomBlocObserver();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const TreeClinic(),
    // ),
    TreeClinic(preferences: preferences, initialLocale: initialLocale),
  );
}