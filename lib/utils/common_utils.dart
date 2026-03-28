

import 'package:car_wash/widgets/loader_transparent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CommonUtils{

  static Widget loader(){
    // return const LoaderTransparent();
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

  static String cycle(String cycle){

    switch(cycle){
      case 'MONTHLY':
        return 'Monthly';
      case 'QUARTERLY':
        return 'Quartely';

      case 'YEARLY':
        return 'Yearly';

      default:
        return 'One Time';
    }


  }
  static String vehicleType(String type){

    if(type=='CAR'){
      return 'Car';
    }
    return 'Two Wheeler';
  }
  static String vehicleSize(String size){

    switch(size){

      case 'HATCHBACK':
        return 'Hatch Back';

      case 'SEDAN':
        return 'Sedan';
      case 'COMPACT_SUV':
        return 'Compact SUV';
      case 'HYBRID':
        return 'Hybrid';

      default:
        return size;
    }
  }

  static String  ddMmYy(DateTime date){

    return  DateFormat('dd MMM yyyy').format(date);
  }



}