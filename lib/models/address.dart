

class Address {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressLine3;
  final String? addressLine4;
  final String? city;
  final String? district;
  final String? pinCode;
  final String? state;
  final int? userId;
  final String? type;
  final String? vehicleId;
  final String? houseNo;
  final int? masterAddressId;


  const Address( {
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.pinCode,
    this.state,
    this.district,
    this.userId,
    this.type,
    this.firstName,
    this.lastName,
    this.addressLine3,
    this.addressLine4,
    this.vehicleId,
    this.houseNo,
    this.masterAddressId,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      pinCode:json['pinCode'].toString(),
      district:json['district'],
      userId:json['userId'],
      type:json['type'],
      state:json['state'],
      addressLine3:json['addressLine3'],
      addressLine4:json['addressLine4'],
      vehicleId:json['vehicleId'],
      houseNo:json['houseNo'],
      masterAddressId:json['masterAddressId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "city": city,
      "pinCode": pinCode,
      "district": district,
      "userId": userId,
      "state": state,
      "addressLine3": addressLine3,
      "addressLine4": addressLine4,
      "houseNo": houseNo,
      "type": type,
      "masterAddressId": masterAddressId,
    };
  }
}