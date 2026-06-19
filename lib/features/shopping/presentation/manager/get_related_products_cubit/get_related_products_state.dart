part of 'get_related_products_cubit.dart';

@immutable
sealed class GetRelatedProductsState {}

final class GetRelatedProductsInitial extends GetRelatedProductsState {}

final class GetRelatedProductsSuccess extends GetRelatedProductsState {
  final List<ProductModel> products;

  GetRelatedProductsSuccess({required this.products});
}

final class GetRelatedProductsFailure extends GetRelatedProductsState {
  final String errMessage;

  GetRelatedProductsFailure({required this.errMessage});
}

final class GetRelatedProductsLoading extends GetRelatedProductsState {}
