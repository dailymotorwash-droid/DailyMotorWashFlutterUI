import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/vehicle_color.dart';

class VehicleColorResponse extends Response{

  late List<VehicleColor> data;
  late VehicleColor color;

  VehicleColorResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){

    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => VehicleColor.fromJson(e))
          .toList();
    }else if (json['data'] != null){
      color = VehicleColor.fromJson(json['data']);
    }
  }


}