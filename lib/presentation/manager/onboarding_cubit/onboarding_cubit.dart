import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/app/router/app_router.dart';
import 'package:tree_clinic/presentation/models/on_boarding_model.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this.onboadingList, this.pageController)
    : super(OnboardingInitial());
  final PageController pageController;
  final List<OnBoardingModel> onboadingList;
  int currentPage = 0;

  void changePage(int index) {
    currentPage = index;
    emit(OnboardingPageChanged(index));
  }

  void nextPage(BuildContext context) {
    if (currentPage < onboadingList.length - 1) {
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: Duration(microseconds: 500),
        curve: Curves.easeInOut,
      );
      emit(OnboardingPageChanged(currentPage));
    } else {
      GoRouter.of(context).pushReplacement(AppRouter.kSigninView);
      emit(OnboardingFinished());
    }
  }
}
