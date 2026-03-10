

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonUtils{

  static Widget loader(){
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    );
  }

  static String weightConverter(String weight){
    int w = double.parse(weight).round();
    if (w == 0) {
      int fw = (double.parse(weight) * 1000.round()) as int;
      return "$fw gm";
    } else {
      int fw = double.parse(weight).round();
      return "$fw kg";
    }
  }

  static Future<bool?> toastMessage(String message){
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  

}