import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/master_address.dart';

class SearchAddressResponse extends Response{

  late List<MasterAddress> data;

  SearchAddressResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => MasterAddress.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }


}