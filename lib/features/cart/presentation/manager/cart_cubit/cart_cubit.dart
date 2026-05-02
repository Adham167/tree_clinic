import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_clinic/features/cart/data/model/cart_item.dart';
import 'package:tree_clinic/features/cart/data/model/delivery_details.dart';
import 'package:tree_clinic/features/cart/data/model/merchant_order_request_model.dart';
import 'package:tree_clinic/features/cart/data/model/order_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<List<CartItem>> {
  CartCubit() : super([]) {
    _loadCartFromFirestore();
  }

  double get totalPrice =>
      state.fold(0, (currentTotal, item) => currentTotal + item.totalPrice);

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
    } catch (_) {
      emit([]);
    }
  }

  Future<void> _saveCartToFirestore(List<CartItem> items) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final Map<String, dynamic> data = {
      'items': items.map((item) => item.toJson()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await FirebaseFirestore.instance.collection('carts').doc(userId).set(data);
  }

  Future<void> addItem(CartItem newItem) async {
    final existingIndex = state.indexWhere((item) => item.id == newItem.id);
    List<CartItem> updatedList;

    if (existingIndex != -1) {
      updatedList = List<CartItem>.from(state);
      updatedList[existingIndex] = updatedList[existingIndex].copyWith(
        quantity: updatedList[existingIndex].quantity + 1,
      );
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
      updatedList[index] = updatedList[index].copyWith(
        quantity: updatedList[index].quantity + 1,
      );
      emit(updatedList);
      await _saveCartToFirestore(updatedList);
    }
  }

  Future<void> decreaseQty(String productId) async {
    final updatedList = List<CartItem>.from(state);
    final index = updatedList.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (updatedList[index].quantity > 1) {
        updatedList[index] = updatedList[index].copyWith(
          quantity: updatedList[index].quantity - 1,
        );
      } else {
        updatedList.removeAt(index);
      }
      emit(updatedList);
      await _saveCartToFirestore(updatedList);
    }
  }

  Future<void> removeItem(String productId) async {
    final updatedList = List<CartItem>.from(state);
    updatedList.removeWhere((item) => item.id == productId);
    emit(updatedList);
    await _saveCartToFirestore(updatedList);
  }

  Future<DeliveryDetails> loadDeliveryDetailsDraft() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return DeliveryDetails.empty();
    }

    final buyerProfile = await _loadBuyerProfile(currentUser.uid);
    return DeliveryDetails(
      fullName: buyerProfile.name,
      governorate: buyerProfile.governorate,
      address: buyerProfile.address,
      phone: buyerProfile.phone,
      placeType:
          buyerProfile.placeType.trim().isNotEmpty
              ? buyerProfile.placeType
              : 'House',
      availability: buyerProfile.availability,
      placeAvailability: buyerProfile.placeAvailability,
    );
  }

  Future<void> checkout({required DeliveryDetails deliveryDetails}) async {
    if (state.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final buyerProfile = await _loadBuyerProfile(currentUser.uid);
    final sanitizedDeliveryDetails = deliveryDetails.copyWith(
      fullName:
          deliveryDetails.fullName.trim().isNotEmpty
              ? deliveryDetails.fullName.trim()
              : buyerProfile.name,
      phone:
          deliveryDetails.phone.trim().isNotEmpty
              ? deliveryDetails.phone.trim()
              : buyerProfile.phone,
      governorate: deliveryDetails.governorate.trim(),
      address: deliveryDetails.address.trim(),
      placeType:
          deliveryDetails.placeType.trim().isNotEmpty
              ? deliveryDetails.placeType.trim()
              : 'House',
      availability: '',
      placeAvailability: deliveryDetails.placeAvailability.trim(),
    );
    final shopsById = await _loadShopsById(
      state
          .map((item) => item.shopId)
          .where((id) => id.trim().isNotEmpty)
          .toSet(),
    );

    final firestore = FirebaseFirestore.instance;
    final orderRef = firestore.collection('orders').doc();
    final now = DateTime.now();
    final order = OrderModel(
      id: orderRef.id,
      userId: currentUser.uid,
      buyerName: sanitizedDeliveryDetails.fullName,
      buyerEmail: buyerProfile.email,
      buyerPhone: sanitizedDeliveryDetails.phone,
      deliveryDetails: sanitizedDeliveryDetails,
      items: List<CartItem>.from(state),
      total: totalPrice,
      createdAt: now,
      status: 'awaiting_merchant_approval',
    );

    final batch = firestore.batch();
    batch.set(orderRef, order.toJson());

    for (final item in state) {
      final shopData = shopsById[item.shopId];
      if (shopData == null || shopData.ownerId.trim().isEmpty) {
        throw Exception('Missing merchant shop data for ${item.name}.');
      }

      final requestRef = firestore.collection('merchant_order_requests').doc();
      final request = MerchantOrderRequestModel(
        id: requestRef.id,
        orderId: order.id,
        merchantId: shopData.ownerId,
        shopId: item.shopId,
        buyerId: currentUser.uid,
        buyerName: sanitizedDeliveryDetails.fullName,
        buyerEmail: buyerProfile.email,
        buyerPhone: sanitizedDeliveryDetails.phone,
        deliveryDetails: sanitizedDeliveryDetails,
        productId: item.id,
        productName: item.name,
        productImage: item.image,
        productTree: item.tree,
        productDisease: item.disease,
        quantity: item.quantity,
        unitPrice: item.price,
        totalPrice: item.totalPrice,
        status: 'pending',
        createdAt: now,
      );
      batch.set(requestRef, request.toJson());
    }

    try {
      await batch.commit();
      await _persistDeliveryDetails(
        userId: currentUser.uid,
        email: buyerProfile.email,
        deliveryDetails: sanitizedDeliveryDetails,
      );
      emit([]);
      await _saveCartToFirestore([]);
    } catch (error) {
      throw Exception('Failed to submit order for merchant approval: $error');
    }
  }

  Future<void> clearCart() async {
    emit([]);
    await _saveCartToFirestore([]);
  }

  Future<_BuyerProfile> _loadBuyerProfile(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    final data = doc.data() ?? const <String, dynamic>{};
    return _BuyerProfile(
      name:
          data['fullname']?.toString().trim().isNotEmpty == true
              ? data['fullname'].toString().trim()
              : FirebaseAuth.instance.currentUser?.displayName
                      ?.trim()
                      .isNotEmpty ==
                  true
              ? FirebaseAuth.instance.currentUser!.displayName!.trim()
              : 'Unknown Buyer',
      email:
          data['email']?.toString() ??
          FirebaseAuth.instance.currentUser?.email ??
          '',
      phone: data['phone']?.toString() ?? '',
      governorate: data['governorate']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      placeType: data['deliveryPlaceType']?.toString() ?? '',
      availability: data['deliveryAvailability']?.toString() ?? '',
      placeAvailability: data['deliveryLocationAvailability']?.toString() ?? '',
    );
  }

  Future<void> _persistDeliveryDetails({
    required String userId,
    required String email,
    required DeliveryDetails deliveryDetails,
  }) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).set({
      'fullname': deliveryDetails.fullName,
      'email': email,
      'phone': deliveryDetails.phone,
      'governorate': deliveryDetails.governorate,
      'address': deliveryDetails.address,
      'deliveryPlaceType': deliveryDetails.placeType,
      'deliveryAvailability': '',
      'deliveryLocationAvailability': deliveryDetails.placeAvailability,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, _ShopData>> _loadShopsById(Set<String> shopIds) async {
    final entries = await Future.wait(
      shopIds.map((shopId) async {
        final doc =
            await FirebaseFirestore.instance
                .collection('shops')
                .doc(shopId)
                .get();
        final data = doc.data() ?? const <String, dynamic>{};
        return MapEntry(
          shopId,
          _ShopData(ownerId: data['ownerId']?.toString() ?? ''),
        );
      }),
    );

    return Map<String, _ShopData>.fromEntries(entries);
  }
}

class _BuyerProfile {
  const _BuyerProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.governorate,
    required this.address,
    required this.placeType,
    required this.availability,
    required this.placeAvailability,
  });

  final String name;
  final String email;
  final String phone;
  final String governorate;
  final String address;
  final String placeType;
  final String availability;
  final String placeAvailability;
}

class _ShopData {
  const _ShopData({required this.ownerId});

  final String ownerId;
}
