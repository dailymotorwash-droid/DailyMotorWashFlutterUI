import 'package:car_wash/ApiResponse/Response.dart';
import 'package:car_wash/models/user.dart';

class LogInResponse extends Response {
  late User data;
  LogInResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = User.fromJson(json['data']);
  }
}
