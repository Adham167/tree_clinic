import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/app_colors.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/profile/presentation/manager/app_locale_cubit.dart';

class AuthLanguageButton extends StatelessWidget {
  const AuthLanguageButton({super.key, this.onDarkBackground = false});

  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocaleCubit, Locale>(
      builder: (context, locale) {
        final textColor =
            onDarkBackground ? Colors.white : AppColors.lightTextPrimary;
        final borderColor =
            onDarkBackground
                ? Colors.white.withValues(alpha: 0.35)
                : Colors.green.withValues(alpha: 0.22);
        final backgroundColor =
            onDarkBackground
                ? Colors.black.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.94);

        return PopupMenuButton<String>(
          tooltip: context.tr('Language'),
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: (value) {
            context.read<AppLocaleCubit>().setLanguageCode(value);
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      if (locale.languageCode == 'en')
                        const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8),
                          child: Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.green,
                          ),
                        )
                      else
                        const SizedBox(width: 26),
                      Text(context.tr('English')),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'ar',
                  child: Row(
                    children: [
                      if (locale.languageCode == 'ar')
                        const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8),
                          child: Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.green,
                          ),
                        )
                      else
                        const SizedBox(width: 26),
                      Text(context.tr('Arabic')),
                    ],
                  ),
                ),
              ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, size: 18, color: textColor),
                const SizedBox(width: 8),
                Text(
                  context.tr(
                    locale.languageCode == 'ar' ? 'Arabic' : 'English',
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: textColor),
              ],
            ),
          ),
        );
      },
    );
  }
}
