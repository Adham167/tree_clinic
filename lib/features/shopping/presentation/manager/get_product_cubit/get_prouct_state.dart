// get_products_state.dart
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';


abstract class GetProductsState {}
class GetProductsInitial extends GetProductsState {}
class GetProductsLoading extends GetProductsState {}
class GetProductsSuccess extends GetProductsState {
  final List<ProductModel> products;
  GetProductsSuccess(this.products);
}
class GetProductsFailure extends GetProductsState {
  final String errMessage;
  GetProductsFailure({required this.errMessage});
}