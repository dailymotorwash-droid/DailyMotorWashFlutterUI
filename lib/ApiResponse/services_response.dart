import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/master_address.dart';

import '../models/service.dart';

class ServicesResponse extends Response{

  late List<Service> data;

  ServicesResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Service.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }


}