part of 'get_started_cubit.dart';

@immutable
sealed class GetStartedState {}
final class Authenticated extends GetStartedState {}
final class UnAuthenticated extends GetStartedState {}
final class GetStartedInitial extends GetStartedState {}
