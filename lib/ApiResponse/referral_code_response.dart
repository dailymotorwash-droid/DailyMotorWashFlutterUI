import 'package:dmw/ApiResponse/Response.dart';

class ReferralCodeResponse extends Response{
  late String data;
  ReferralCodeResponse.fromJson(Map<String,dynamic> json) : super.fromJson(json){
    if(json['data']!=null){
      data = json['data'];
    }
  }

}