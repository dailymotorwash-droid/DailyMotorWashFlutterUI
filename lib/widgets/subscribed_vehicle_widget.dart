import 'package:car_wash/models/address.dart';
import 'package:car_wash/models/subscription_vehicle.dart';
import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/views/select_plan_screen.dart/select_plan_screen.dart';
import 'package:flutter/material.dart';

class SubscribedVehicleWidget extends StatefulWidget {

  final SubscriptionVehicle vehicle;
  final bool isClickable;
  final ColorTheme colorTheme;
  final Address address;

  const SubscribedVehicleWidget({
    super.key,
    this.isClickable = true,
    this.colorTheme = ColorTheme.light,
    required this.vehicle,
    required this.address,
  });

  @override
  State<SubscribedVehicleWidget> createState() => _SubscribedVehicleWidget();
}

class _SubscribedVehicleWidget extends State<SubscribedVehicleWidget> {
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
            widget.vehicle.vehicleType==VehicleType.car.label?Image.asset('assets/images/car.png',height: 80,width: 80,):Image.asset('assets/images/bike.png',height: 80,width: 80,),
            const SizedBox(width: 16),
            /// LEFT SIDE (Vehicle Info)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vehicle.registrationNumber!,
                    style: widget.colorTheme == ColorTheme.light
                        ? AppTextStyles.blackFont16Bold
                        : AppTextStyles.whiteFont16Bold,
                  ),
                  Text(
                    '${widget.vehicle.brand} ${widget.vehicle.model}',
                    style: widget.colorTheme == ColorTheme.light
                        ? AppTextStyles.blackFont12Regular
                        : AppTextStyles.whiteFont12Regular,
                  ),
                  Text(
                    'Service Ex .D. : ${CommonUtils.ddMmYy(widget.vehicle.endDate!)}',
                    style: widget.colorTheme == ColorTheme.light
                        ? AppTextStyles.blackFont12Regular
                        : AppTextStyles.whiteFont12Regular,
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE (Status Indicator)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.vehicle.status == 'ACTIVE'|| widget.vehicle.status=='QUEUE'
                    ? Colors.green.withOpacity(0.15)
                    : Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: widget.vehicle.status == 'ACTIVE'|| widget.vehicle.status=='QUEUE'
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.vehicle.status == 'ACTIVE'|| widget.vehicle.status=='QUEUE'?'ACTIVE':'EXPIRED',
                    style: TextStyle(
                      color: widget.vehicle.status == 'ACTIVE'|| widget.vehicle.status=='QUEUE'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleClickToSeePlans() {
    var sub = widget.vehicle;
    Vehicle veh = Vehicle(
        vehicleType: sub.vehicleType,
        model: sub.model,
        brand: sub.brand,
        registrationNumber: sub.registrationNumber,
        addressId: sub.addressId,
        nickName: sub.nickName,
        color: sub.color,
        size: sub.size,
        id: sub.vehicleId);

    Navigator.push(
        context, MaterialPageRoute(builder:
        (context) => SelectPlanScreen(vehicle: veh, address: widget.address,)));
  }
}