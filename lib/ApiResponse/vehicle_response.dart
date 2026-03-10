import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/vehicle.dart';

class VehicleResponse extends Response{
  late List<Vehicle> data;
  VehicleResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Vehicle.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }

}