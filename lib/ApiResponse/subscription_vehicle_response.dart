
import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/subscription_vehicle.dart';

class SubscriptionVehicleResponse extends Response{

  late List<SubscriptionVehicle> data;

  SubscriptionVehicleResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if(json['data']!=null&&json['data'] is List){
      data = data = (json['data'] as List)
          .map((e) => SubscriptionVehicle.fromJson(e))
          .toList();
    }

  }




}