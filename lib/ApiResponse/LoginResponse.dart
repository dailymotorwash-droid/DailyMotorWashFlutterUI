import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/models/user.dart';

class LogInResponse extends Response {
  late User data;
  LogInResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = User.fromJson(json['data']);
  }
}
