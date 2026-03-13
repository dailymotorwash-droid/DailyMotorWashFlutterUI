import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/vehicle_color.dart';

class VehicleColorResponse extends Response{

  late List<VehicleColor> data;

  VehicleColorResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){

    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => VehicleColor.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }


}