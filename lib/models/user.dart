import 'package:dmw/models/address.dart';
import 'package:dmw/models/vehicle.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? email;
  final String? state;
  final String phone;
  final String? gender;
  final String? token;
  final String? status;
  final int? referredBy;
  final int? points;
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
    this.referredBy,
    this.points,
    required this.phone,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone:json['phone'].toString(),
      token:json['token'],
      status:json['status'],
      referredBy:json['referredBy'],
      points:json['points'],
      gender:json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "gender": gender,
      "referredBy": referredBy,
      "phone": phone,
      "token": token,
    };
  }
}