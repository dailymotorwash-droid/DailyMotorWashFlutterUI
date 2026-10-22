import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/schedule_slot.dart';

class SlotResponse extends Response{

  late List<DaySchedule> data;

  SlotResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => DaySchedule.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }


}