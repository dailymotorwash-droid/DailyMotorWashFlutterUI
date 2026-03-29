import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/subscription.dart';

class SubscriptionResponse extends Response {
  late Subscription? data;

  SubscriptionResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['data'] != null) {
      data = Subscription.fromJson(json['data']);
    }else{
      data = null;
    }
  }
}
