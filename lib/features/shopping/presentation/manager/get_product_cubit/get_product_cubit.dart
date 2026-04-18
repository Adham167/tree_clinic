// features/shopping/presentation/manager/get_products_cubit/get_products_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';
import 'package:tree_clinic/features/shopping/presentation/manager/get_product_cubit/get_prouct_state.dart';


class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit() : super(GetProductsInitial());

  Future<void> fetchAllProducts() async {
    emit(GetProductsLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      final products = snapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data(), doc.id);
      }).toList();

      emit(GetProductsSuccess(products));
    } catch (e) {
      emit(GetProductsFailure(errMessage: e.toString()));
    }
  }
}