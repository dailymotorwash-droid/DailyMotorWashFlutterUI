import '../models/user.dart';
import 'Response.dart';

class UserProfileResponse extends Response{

  late User data;

  UserProfileResponse.fromJson(Map<String,dynamic> json): super.fromJson(json){
    if (json['data'] != null){
      data = User.fromJson(json['data']);
    }
  }
}