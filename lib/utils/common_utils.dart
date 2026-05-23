

import 'package:another_flushbar/flushbar.dart';
import 'package:dmw/widgets/loader_transparent.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class CommonUtils{
  static late BuildContext context;
  static void init(BuildContext ctx){
    context = ctx;
}

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

  static void toastMessage(String message) async {
    // return
    //   Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    //   Flushbar(
    //     message: message,
    //     duration: const Duration(seconds: 2),
    //     flushbarPosition: FlushbarPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     messageColor: Colors.white,
    //     messageText: Text(
    //       message,
    //       textAlign: TextAlign.center,
    //       style: const TextStyle(
    //         color: Colors.white,
    //         fontSize: 16,
    //       ),
    //     ),
    //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    //     borderRadius: BorderRadius.circular(25),
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 16,
    //       vertical: 12,
    //     ),
    //     animationDuration: const Duration(milliseconds: 300),
    //   ).show(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          duration: const Duration(seconds: 2),
        ),
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

      case 'HALF_YEARLY':
        return 'Half Yearly';

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