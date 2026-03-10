
class Vehicle {
  final String? id;
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

  const Vehicle( {
    this.vehicleType,
    this.model,
    this.brand,
    this.category,
    this.registrationNumber,
    this.addressId,
    this.nickName, this.color, this.size, this.userId, this.id,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      addressId: json['addressId'],
      brand: json['brand'],
      color: json['color'],
      model:json['model'],
      nickName:json['nickName'],
      size:json['size'],
      userId:json['userId'],
      vehicleType:json['vehicleType'],
      registrationNumber:json['registrationNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "addressId": addressId,
      "brand": brand,
      "color": color,
      "model": model,
      "nickName": nickName,
      "registrationNumber": registrationNumber,
      "size": size,
      "userId": userId,
      "vehicleType": vehicleType,
    };
  }
}