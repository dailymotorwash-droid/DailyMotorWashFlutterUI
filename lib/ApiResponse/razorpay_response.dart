
import 'package:dmw/models/razorpay.dart';

class RazorpayResponse{

  late Razorpay data;

  RazorpayResponse.fromJson(Map<String,dynamic> json){
    data=  Razorpay.fromJson(json);
  }

}