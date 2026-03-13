
import 'package:flutter/material.dart';

class LoaderTransparent extends StatelessWidget {

  // double height;
  // double width;
  // Color colorValue;
  const LoaderTransparent({super.key,/*required this.colorValue*/});





  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        width: width,
        color: Colors.transparent,
        child: const Center(
            child: SizedBox(
                height: 60.0,
                width: 60.0,
                child:
                //Image.asset('assets/images/loader.gif',fit: BoxFit.fill,) // use you custom loader or default loader
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        Colors.red),
                    strokeWidth: 5.0))));
  }
}
