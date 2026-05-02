class DeliveryDetails {
  const DeliveryDetails({
    required this.fullName,
    required this.governorate,
    required this.address,
    required this.phone,
    required this.placeType,
    required this.availability,
    required this.placeAvailability,
  });

  factory DeliveryDetails.empty() {
    return const DeliveryDetails(
      fullName: '',
      governorate: '',
      address: '',
      phone: '',
      placeType: 'House',
      availability: '',
      placeAvailability: '',
    );
  }

  factory DeliveryDetails.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const <String, dynamic>{};
    return DeliveryDetails(
      fullName: data['fullName']?.toString() ?? '',
      governorate: data['governorate']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      placeType:
          data['placeType']?.toString().trim().isNotEmpty == true
              ? data['placeType'].toString()
              : 'House',
      availability: data['availability']?.toString() ?? '',
      placeAvailability: data['placeAvailability']?.toString() ?? '',
    );
  }

  final String fullName;
  final String governorate;
  final String address;
  final String phone;
  final String placeType;
  final String availability;
  final String placeAvailability;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'governorate': governorate,
      'address': address,
      'phone': phone,
      'placeType': placeType,
      'availability': availability,
      'placeAvailability': placeAvailability,
    };
  }

  DeliveryDetails copyWith({
    String? fullName,
    String? governorate,
    String? address,
    String? phone,
    String? placeType,
    String? availability,
    String? placeAvailability,
  }) {
    return DeliveryDetails(
      fullName: fullName ?? this.fullName,
      governorate: governorate ?? this.governorate,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      placeType: placeType ?? this.placeType,
      availability: availability ?? this.availability,
      placeAvailability: placeAvailability ?? this.placeAvailability,
    );
  }
}
