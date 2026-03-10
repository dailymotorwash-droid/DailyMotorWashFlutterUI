import 'package:car_wash/models/address.dart';
import 'package:car_wash/models/vehicle.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? email;
  final String? state;
  final String phoneNumber;
  final String? gender;
  final String? token;
  final String? status;
  final List<Vehicle>? vehicleList;
  final List<Address>? addressList;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.email,
    this.state,
    this.vehicleList,
    this.addressList,
    this.gender,
    this.token,
    this.status,
    required this.phoneNumber,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber:json['phone'],
      token:json['token'],
        status:json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "token": token,
      "status": status,
    };
  }
}