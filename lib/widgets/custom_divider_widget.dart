import 'package:dmw/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDividerWidget extends StatelessWidget {

  final double heigth;
  final double width;
  final Color color;
  final EdgeInsetsGeometry? margin;

  const CustomDividerWidget({ 
    super.key,
    this.color = AppColors.black,
    this.margin,
    required this.heigth,
    required this.width,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      height: heigth, // Set the height of the vertical line
      width: width, // Set the width of the vertical line
      color: color, // Set the color of the vertical line
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 0), // Add some spacing
    );
  }
}