part of 'add_shop_cubit.dart';

@immutable
sealed class AddShopState {}

final class AddShopInitial extends AddShopState {}

final class AddShopSuccess extends AddShopState {}

final class AddShopFailure extends AddShopState {
  final String errMessage;

  AddShopFailure({required this.errMessage});
}

final class AddShopLoading extends AddShopState {}
