import 'package:bloc/bloc.dart';
import 'package:tree_clinic/features/cart/data/model/cart_item.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]);

  void addItem(CartItem item) {
    final index = state.indexWhere((e) => e.id == item.id);

    if (index != -1) {
      state[index].quantity++;
      emit(List.from(state));
    } else {
      emit([...state, item]);
    }
  }

  void removeItem(String id) {
    emit(state.where((item) => item.id != id).toList());
  }

  void increaseQty(String id) {
    final item = state.firstWhere((e) => e.id == id);
    item.quantity++;
    emit(List.from(state));
  }

  void decreaseQty(String id) {
    final item = state.firstWhere((e) => e.id == id);

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      removeItem(id);
      return;
    }

    emit(List.from(state));
  }

  double get totalPrice {
    return state.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void clearCart() {
    emit([]);
  }
}