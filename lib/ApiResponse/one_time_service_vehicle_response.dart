
import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/one_time_booking_vehicle.dart';
import 'package:dmw/models/subscription_vehicle.dart';

class OneTimeServiceVehicleResponse extends Response{

  late List<OneTimeBookingVehicle> data;

  OneTimeServiceVehicleResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if(json['data']!=null&&json['data'] is List){
      data = data = (json['data'] as List)
          .map((e) => OneTimeBookingVehicle.fromJson(e))
          .toList();
    }

  }




}