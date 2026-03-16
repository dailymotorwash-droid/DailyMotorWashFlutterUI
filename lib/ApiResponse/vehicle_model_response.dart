import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/model.dart';

import '../models/vehicle.dart';

class VehicleModelResponse extends Response{

  late List<Model> data;
  late Model model;

  VehicleModelResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Model.fromJson(e))
          .toList();
    }else if(json['data'] != null) {
      model = Model.fromJson(json['data']);
    }
  }



}