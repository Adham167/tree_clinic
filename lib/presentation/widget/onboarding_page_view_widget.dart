
import 'package:flutter/material.dart';
import 'package:tree_clinic/core/constants/app_styles.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';

class OnboardingPageViewWidget extends StatelessWidget {
  const OnboardingPageViewWidget({
    super.key,
    required this.onboardingList,
  });

  final List<OnBoardingModel> onboardingList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        itemCount: onboardingList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Spacer(flex: 3),
              Image.asset(onboardingList[index].image),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
    
                  children: [
                    Text(
                      onboardingList[index].title,
                      style: AppStyles.styleBold36.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      onboardingList[index].description,
                      style: AppStyles.styleMedium13,
                    ),
                  ],
                ),
              ),
    
              Spacer(flex: 5),
            ],
          );
        },
      ),
    );
  }
}
