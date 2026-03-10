
import '../models/user.dart';
import 'Response.dart';

class VerifyOTPResponse extends Response {
  late User data;

  VerifyOTPResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
     if(json['data']!=null){
       data = User.fromJson(json['data']);

     }


  }
}
