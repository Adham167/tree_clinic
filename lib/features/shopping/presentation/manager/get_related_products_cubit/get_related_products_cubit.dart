import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tree_clinic/features/shopping/data/model/product_model.dart';

part 'get_related_products_state.dart';

class GetRelatedProductsCubit extends Cubit<GetRelatedProductsState> {
  GetRelatedProductsCubit() : super(GetRelatedProductsInitial());

  Future<void> fetchRelatedProducts({
    required String treeName,
    required String currentProductId,
  }) async {
    emit(GetRelatedProductsLoading());

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('tree', isEqualTo: treeName)
              .get();

      final products =
          snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .where((product) => product.id != currentProductId)
              .toList();

      emit(GetRelatedProductsSuccess(products: products));
    } catch (e) {
      emit(GetRelatedProductsFailure(errMessage: e.toString()));
      log(e.toString());
    }
  }
}
