import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/address.dart';

class AddressResponse extends Response{

  late List<Address> data;
  late Address address;

  AddressResponse.fromJson(Map<String,dynamic> json): super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Address.fromJson(e))
          .toList();
    }else if(json['data'] != null){
      address = Address.fromJson(json['data']);
    }
  }
}