part of 'get_shop_cubit.dart';

sealed class GetShopState {}

final class GetShopInitial extends GetShopState {}

final class GetShopLoading extends GetShopState {}

final class GetShopSuccess extends GetShopState {
  final ShopEntity shopEntity;

  GetShopSuccess({required this.shopEntity});
}

final class GetShopFailure extends GetShopState {
  final String errMessage;

  GetShopFailure({required this.errMessage});
}

class GetShopEmpty extends GetShopState {}
