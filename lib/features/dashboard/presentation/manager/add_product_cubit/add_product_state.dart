// add_product_state.dart
part of 'add_product_cubit.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final String message;

  AddProductSuccess({this.message = "Product saved successfully."});
}

class AddProductFailure extends AddProductState {
  final String errMessage;
  AddProductFailure({required this.errMessage});
}
