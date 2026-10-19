class OneTimeBookingData {
  final String id;
  final int userId;
  final String vehicleId;
  final int serviceId;
  final int rateId;
  final double rate;
  final double discount;
  final String bookingDate;
  final String paymentId;
  final int slotInventoryId;
  final String addressId;
  final String slotStartTime;
  final String slotEndTime;
  final String slotLabel;
  final String status;

  OneTimeBookingData({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.serviceId,
    required this.rateId,
    required this.rate,
    required this.discount,
    required this.bookingDate,
    required this.paymentId,
    required this.slotInventoryId,
    required this.addressId,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.slotLabel,
    required this.status,
  });

  factory OneTimeBookingData.fromJson(Map<String, dynamic> json) {
    return OneTimeBookingData(
      id: json['id']?.toString() ?? '',
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse('${json['userId']}') ?? 0,
      vehicleId: json['vehicleId']?.toString() ?? '',
      serviceId: json['serviceId'] is int
          ? json['serviceId']
          : int.tryParse('${json['serviceId']}') ?? 0,
      rateId: json['rateId'] is int
          ? json['rateId']
          : int.tryParse('${json['rateId']}') ?? 0,
      rate: json['rate'] is num
          ? (json['rate'] as num).toDouble()
          : double.tryParse('${json['rate']}') ?? 0.0,
      discount: json['discount'] is num
          ? (json['discount'] as num).toDouble()
          : double.tryParse('${json['discount']}') ?? 0.0,
      bookingDate: json['bookingDate']?.toString() ?? '',
      paymentId: json['paymentId']?.toString() ?? '',
      slotInventoryId: json['slotInventoryId'] is int
          ? json['slotInventoryId']
          : int.tryParse('${json['slotInventoryId']}') ?? 0,
      addressId: json['addressId']?.toString() ?? '',
      slotStartTime: json['slotStartTime']?.toString() ?? '',
      slotEndTime: json['slotEndTime']?.toString() ?? '',
      slotLabel: json['slotLabel']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'serviceId': serviceId,
      'rateId': rateId,
      'rate': rate,
      'discount': discount,
      'bookingDate': bookingDate,
      'paymentId': paymentId,
      'slotInventoryId': slotInventoryId,
      'addressId': addressId,
      'slotStartTime': slotStartTime,
      'slotEndTime': slotEndTime,
      'slotLabel': slotLabel,
      'status': status,
    };
  }
}