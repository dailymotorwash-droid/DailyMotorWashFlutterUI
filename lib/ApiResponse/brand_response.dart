import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/brand.dart';

class BrandResponse extends Response{

  late List<Brand> data;

  BrandResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Brand.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }


}