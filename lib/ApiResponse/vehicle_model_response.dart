import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/model.dart';

class VehicleModelResponse extends Response{

  late List<Model> data;

  VehicleModelResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Model.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }



}