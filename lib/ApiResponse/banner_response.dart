import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/banner_model.dart';

class BannerResponse extends Response{

  late List<BannerModel> data;
  late BannerModel brand;

  BannerResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => BannerModel.fromJson(e))
          .toList();
    }else  if (json['data'] != null) {
      brand = BannerModel.fromJson(json['data']);
    }
  }


}