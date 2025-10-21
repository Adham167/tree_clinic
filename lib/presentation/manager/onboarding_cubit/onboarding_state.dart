part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingPageChanged extends OnboardingState {
  final int index;

  OnboardingPageChanged(this.index);
}

final class OnboardingFinished extends OnboardingState {}
