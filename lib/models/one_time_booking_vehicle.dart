class OneTimeBookingVehicle {
  final String id;
  final int userId;
  final String vehicleId;
  final String brand;
  final String model;
  final String nickName;
  final String registrationNumber;
  final String vehicleType;
  final String bookingDate;
  final String slotStartTime;
  final String slotEndTime;
  final String slotLabel;
  final String status;

  OneTimeBookingVehicle({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.brand,
    required this.model,
    required this.nickName,
    required this.registrationNumber,
    required this.vehicleType,
    required this.bookingDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.slotLabel,
    required this.status,
  });

  factory OneTimeBookingVehicle.fromJson(Map<String, dynamic> json) {
    return OneTimeBookingVehicle(
      id: json['id']?.toString() ?? '',
      userId: json['userId'] is int
          ? json['userId']
          : int.tryParse('${json['userId']}') ?? 0,
      vehicleId: json['vehicleId']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      nickName: json['nickName']?.toString() ?? '',
      registrationNumber: json['registrationNumber']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      bookingDate: json['bookingDate']?.toString() ?? '',
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
      'brand': brand,
      'model': model,
      'nickName': nickName,
      'registrationNumber': registrationNumber,
      'vehicleType': vehicleType,
      'bookingDate': bookingDate,
      'slotStartTime': slotStartTime,
      'slotEndTime': slotEndTime,
      'slotLabel': slotLabel,
      'status': status,
    };
  }
}