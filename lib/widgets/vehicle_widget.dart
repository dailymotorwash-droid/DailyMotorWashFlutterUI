import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/views/select_plan_screen.dart/select_plan_screen.dart';
import 'package:flutter/material.dart';

class VehicleWidget extends StatefulWidget {

  final Vehicle vehicle;
  final bool isClickable;
  final ColorTheme colorTheme;

  const VehicleWidget({ 
    super.key,
    this.isClickable = true,
    this.colorTheme = ColorTheme.light,
    required this.vehicle,
  });

  @override
  State<VehicleWidget> createState() => _VehicleWidgetState();
}

class _VehicleWidgetState extends State<VehicleWidget> {
  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: widget.isClickable ? _handleClickToSeePlans : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: widget.colorTheme == ColorTheme.light ? AppColors.white : AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [ 
            BoxShadow (
              color: widget.colorTheme == ColorTheme.light ? AppColors.secondary : AppColors.black,
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ]
        ),
        child: Row(
          children: [
            Image.asset('assets/images/ToyCar.png', height: 80, width: 80),
            const SizedBox(width: 16),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vehicle.brand!=null?widget.vehicle.brand.toString():CommonUtils.vehicleSize(widget.vehicle.size.toString()),
                    style: widget.colorTheme == ColorTheme.light ? AppTextStyles.blackFont16Bold : AppTextStyles.whiteFont16Bold,
                  ),
                  Text(
                    widget.vehicle.model!=null?widget.vehicle.model.toString():'',
                    style: widget.colorTheme == ColorTheme.light ? AppTextStyles.blackFont12Regular : AppTextStyles.whiteFont12Regular,
                  ),
                  Text(
                    widget.vehicle.registrationNumber !=null?widget.vehicle.registrationNumber.toString():'' ,
                    style: widget.colorTheme == ColorTheme.light ? AppTextStyles.blackFont16Regular : AppTextStyles.whiteFont16Regular,
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  void _handleClickToSeePlans() {
    Navigator.push(
          context, MaterialPageRoute(builder: 
            (context) => SelectPlanScreen(vehicle: widget.vehicle)));
  }
}