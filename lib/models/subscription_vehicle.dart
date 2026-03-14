class SubscriptionVehicle{

  final String? id;
  final String? vehicleId;
  final String? vehicleType;
  final String? model;
  final String? brand;
  final String? category;
  final String? registrationNumber;
  final String? addressId;
  final String? nickName;
  final String? color;
  final String? size;
  final int? userId;
  final String? status;
  final DateTime? nextBillingDate;
  final DateTime? endDate;

  const SubscriptionVehicle({
    this.vehicleType,
    this.model,
    this.brand,
    this.category,
    this.registrationNumber,
    this.addressId,
    this.nickName, this.color, this.size, this.userId, this.id,
    this.vehicleId,this.status,this.nextBillingDate,this.endDate
  });

  factory SubscriptionVehicle.fromJson(Map<String, dynamic> json) {
    return SubscriptionVehicle(
      id: json['id'],
      vehicleId: json['vehicleId'],
      addressId: json['addressId'],
      brand: json['brand'],
      color: json['color'],
      model:json['model'],
      nickName:json['nickName'],
      size:json['size'],
      userId:json['userId'],
      vehicleType:json['vehicleType'],
      registrationNumber:json['registrationNumber'],
      status:json['status'],
      nextBillingDate:DateTime.parse(json['nextBillingDate']),
      endDate:DateTime.parse(json['endDate']),
    );
  }

}