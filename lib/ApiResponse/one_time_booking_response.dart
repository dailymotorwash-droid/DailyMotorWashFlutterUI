import 'package:dmw/models/OneTimeBookingData.dart';

import 'Response.dart';

class OneTimeBookingResponse extends Response{
  late OneTimeBookingData data;
  OneTimeBookingResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    // if (json['data'] != null && json['data'] is List) {
    //   data = (json['data'] as List)
    //       .map((e) => OneTimeBookingData.fromJson(e))
    //       .toList();
    // }else {
      data = OneTimeBookingData.fromJson(json['data']);
    // }
  }

}