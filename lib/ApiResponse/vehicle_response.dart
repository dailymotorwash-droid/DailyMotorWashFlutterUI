import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/vehicle.dart';

class VehicleResponse extends Response{
  late Vehicle vehicle;
  late List<Vehicle> data;
  VehicleResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Vehicle.fromJson(e))
          .toList();
    }else  if (json['data'] != null){
      vehicle = Vehicle.fromJson(json['data']);
    }
  }

}