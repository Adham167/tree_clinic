import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_clinic/features/cart/data/model/cart_item.dart';
import 'package:tree_clinic/features/cart/data/model/order_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    _loadCartFromFirestore();
  }

  double get totalPrice => state.fold(0, (sum, item) => sum + item.totalPrice);

  Future<void> _loadCartFromFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit([]);
      return;
    }

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(userId)
              .get();

      if (doc.exists) {
        final List<dynamic> itemsJson = doc.data()?['items'] ?? [];
        final List<CartItem> cartItems =
            itemsJson
                .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
                .toList();
        emit(cartItems);
      } else {
        emit([]);
      }
    } catch (e) {
      emit([]);
    }
  }

  Future<void> _saveCartToFirestore(List<CartItem> items) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final Map<String, dynamic> data = {
        'items': items.map((item) => item.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(userId)
          .set(data);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  Future<void> addItem(CartItem newItem) async {
    final existingIndex = state.indexWhere((item) => item.id == newItem.id);
    List<CartItem> updatedList;

    if (existingIndex != -1) {
      updatedList = List<CartItem>.from(state);
      updatedList[existingIndex].quantity++;
    } else {
      updatedList = [...state, newItem];
    }

    emit(updatedList);
    await _saveCartToFirestore(updatedList);
  }

  Future<void> increaseQty(String productId) async {
    final updatedList = List<CartItem>.from(state);
    final index = updatedList.indexWhere((item) => item.id == productId);
    if (index != -1) {
      updatedList[index].quantity++;
      emit(updatedList);
      await _saveCartToFirestore(updatedList);
    }
  }

  Future<void> decreaseQty(String productId) async {
    final updatedList = List<CartItem>.from(state);
    final index = updatedList.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (updatedList[index].quantity > 1) {
        updatedList[index].quantity--;
        emit(updatedList);
      } else {
        updatedList.removeAt(index);
        emit(updatedList);
      }
      await _saveCartToFirestore(updatedList);
    }
  }

  Future<void> removeItem(String productId) async {
    final updatedList = List<CartItem>.from(state);
    updatedList.removeWhere((item) => item.id == productId);
    emit(updatedList);
    await _saveCartToFirestore(updatedList);
  }

  Future<void> checkout() async {
    if (state.isEmpty) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final order = OrderModel(
      id: '',
      userId: userId,
      items: List.from(state),
      total: totalPrice,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toJson());

      emit([]);
      await _saveCartToFirestore([]);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> clearCart() async {
    emit([]);
    await _saveCartToFirestore([]);
  }
}
