import 'package:car_wash/models/address.dart';
import 'package:car_wash/models/vehicle.dart';

class VehicleAndAddress {
  final Vehicle? vehicle;
  final Address? address;

  const VehicleAndAddress({this.address, this.vehicle});

  factory VehicleAndAddress.fromJson(Map<String, dynamic> json) {
    return VehicleAndAddress(
        vehicle: Vehicle.fromJson(json['vehicle']), address: Address.fromJson(json['address']));
  }

  Map<String, dynamic> toJson() {

    return{
      'vehicle':vehicle?.toJson(),
      'address':address?.toJson(),
    };

  }
}
