import '../models/user.dart';
import 'Response.dart';

class UserProfileResponse extends Response{

  late User userProfile;

  UserProfileResponse.fromJson(Map<String,dynamic> json): super.fromJson(json){
    userProfile = User.fromJson(json);
  }
}