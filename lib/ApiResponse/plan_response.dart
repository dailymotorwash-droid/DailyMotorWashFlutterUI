import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/plan.dart';

class PlanResponse extends Response{
  late List<Plan> data;
  PlanResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['data'] != null && json['data'] is List) {
      data = (json['data'] as List)
          .map((e) => Plan.fromJson(e))
          .toList();
    }else {
      // data = Vehicle.fromJson(json['data']);
    }
  }

}