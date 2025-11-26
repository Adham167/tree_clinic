import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/features/auth/presentation/manager/button_cubit/button_cubit.dart';

class CustomReactiveButton extends StatelessWidget {
  const CustomReactiveButton({
    super.key,
    required this.onPressed,
    this.height,
    this.title = '',
    this.content,
    this.color,
  });
  final VoidCallback onPressed;
  final double? height;
  final String title;
  final Widget? content;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonCubit, ButtonState>(
      builder: (context, state) {
        if (state is ButtonLoading) {
          return _loading();
        }
        return _initial();
      },
    );
  }

  Widget _loading() {
    return ElevatedButton(
      onPressed: null,

      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // نفس الكلام هنا
        ),
        minimumSize: Size.fromHeight(height ?? 50),
      ),
      child: Container(
        height: height ?? 50,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _initial() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // نفس الكلام هنا
        ),
        minimumSize: Size.fromHeight(height ?? 50),
      ),
      child:
          content ??
          Text(
            title,
            style: AppStyles.styleMedium16.copyWith(color: Colors.white),
          ),
    );
  }
}
