import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/brand.dart';

class BrandResponse extends Response{

  late List<Brand> data;
  late Brand brand;

  BrandResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Brand.fromJson(e))
          .toList();
    }else  if (json['data'] != null) {
      brand = Brand.fromJson(json['data']);
    }
  }


}