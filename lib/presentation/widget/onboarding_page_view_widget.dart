import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';

class OnboardingPageViewWidget extends StatelessWidget {
  const OnboardingPageViewWidget({
    super.key,
    required this.onboardingList,
    required this.pageController,
  });

  final List<OnBoardingModel> onboardingList;
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged:
          (index) =>
              BlocProvider.of<OnboardingCubit>(context).changePage(index),
      itemCount: onboardingList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Image.asset(onboardingList[index].image),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    onboardingList[index].title,
                    style: AppStyles.styleBold36.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 32),
                  Text(
                    onboardingList[index].description,
                    style: AppStyles.styleMedium13,
                  ),
                ],
              ),
            ),
           
          ],
        );
      },
    );
  }
}
