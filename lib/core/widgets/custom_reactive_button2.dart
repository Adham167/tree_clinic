import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';

class CustomReactiveButton2 extends StatelessWidget {
  const CustomReactiveButton2({
    super.key,
    required this.onPressed,
    this.height,
    this.title = '',
    this.content,
    this.color,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final double? height;
  final String title;
  final Widget? content;
  final Color? color;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: Size.fromHeight(height ?? 50),
      ),

      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            isLoading
                ? SizedBox(
                  key: const ValueKey("loading"),
                  height: height ?? 50,
                  child: const Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                : Container(
                  key: const ValueKey("text"),
                  alignment: Alignment.center,
                  height: height ?? 50,
                  child:
                      content ??
                      Text(
                        title,
                        style: AppStyles.styleMedium16.copyWith(
                          color: Colors.white,
                        ),
                      ),
                ),
      ),
    );
  }
}
