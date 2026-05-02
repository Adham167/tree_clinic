import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/app_localizations.dart';

extension LocalizationBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String tr(String key, {Map<String, String>? params}) {
    return l10n.translate(key, params: params);
  }

  bool get isArabicLocale => Localizations.localeOf(this).languageCode == 'ar';
}
