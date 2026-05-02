import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit(this._preferences, Locale initialLocale)
    : super(initialLocale);

  static const _localeKey = 'app_locale';

  final SharedPreferences _preferences;

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;

    await _preferences.setString(_localeKey, locale.languageCode);
    emit(locale);
  }

  Future<void> setLanguageCode(String languageCode) async {
    await setLocale(Locale(languageCode));
  }

  static Locale resolveInitialLocale(SharedPreferences preferences) {
    final savedLanguageCode = preferences.getString(_localeKey);
    if (savedLanguageCode == 'ar') {
      return const Locale('ar');
    }
    return const Locale('en');
  }
}
