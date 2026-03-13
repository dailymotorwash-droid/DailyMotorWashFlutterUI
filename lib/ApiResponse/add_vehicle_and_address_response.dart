import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/vehicle_and_address.dart';

class AddVehicleAndAddressResponse extends Response {
  late VehicleAndAddress data;

  AddVehicleAndAddressResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      data = VehicleAndAddress.fromJson(json['data']);
    }
  }
}
