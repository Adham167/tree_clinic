import 'package:flutter/material.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';

class OnboardingControllar extends StatelessWidget {
  const OnboardingControllar({super.key, required this.onboardingList, required this.currentIndex});

  final List<OnBoardingModel> onboardingList;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            onboardingList.length,
            (index) => AnimatedContainer(
              duration: Duration(seconds: 1),
              margin: EdgeInsets.only(right: 5),
              width: 110,
              height: 4,
              decoration: BoxDecoration(
                color: currentIndex == index?  Colors.black: Colors.blueGrey,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
