import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/vehicle.dart';
import 'package:dmw/providers/one_time_service_provider.dart';
import 'package:dmw/providers/subscription_vehicle_provider.dart';
import 'package:dmw/providers/vehicle_provider.dart';
import 'package:dmw/utils/common_utils.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_enums.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/views/select_plan_screen.dart/select_plan_screen.dart';
import 'package:dmw/views/update_vehicle.dart';
import 'package:dmw/widgets/vehicle_address_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service.dart';

class OtsVehicleWidget extends StatefulWidget {

  final Vehicle vehicle;
  final DateTime time;
  final Service serviceItem;
  const OtsVehicleWidget({
    super.key,
    required this.vehicle, required this.time, required this.serviceItem,
  });

  @override
  State<OtsVehicleWidget> createState() => _OtsVehicleWidgetState();
}

class _OtsVehicleWidgetState extends State<OtsVehicleWidget> {

  late VehicleProvider read,watch;
  late SubscriptionVehicleProvider subWatch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read = context.read<VehicleProvider>();
  }

  @override
  Widget build(BuildContext context){
    subWatch = context.watch<SubscriptionVehicleProvider>();
    return InkWell(
      onTap:  _handleClickToSeePlans ,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          // Selected state: #E8F0F6 with primary red accent border
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            // width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
        widget.vehicle.vehicleType==VehicleType.car.label?Image.asset('assets/images/car.png',height: 80,width: 80,):Image.asset('assets/images/bike.png',height: 80,width: 80,),
            const SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vehicle.brand!=null?widget.vehicle.brand.toString():CommonUtils.vehicleSize(widget.vehicle.size.toString()),
                    style: AppTextStyles.blackFont16Bold,
                  ),
                  Text(
                    widget.vehicle.model!=null?widget.vehicle.model.toString():'',
                    style: AppTextStyles.blackFont12Regular ,
                  ),
                  Text(
                    widget.vehicle.registrationNumber !=null?widget.vehicle.registrationNumber.toString():'' ,
                    style: AppTextStyles.blackFont16Regular ,
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget editableVehicles(){

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:  AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.secondary,
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            widget.vehicle.vehicleType==VehicleType.car.label?Image.asset('assets/images/car.png',height: 80,width: 80,):Image.asset('assets/images/bike.png',height: 80,width: 80,),

            const SizedBox(width: 16),

            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vehicle.brand != null
                        ? widget.vehicle.brand.toString()
                        : CommonUtils.vehicleSize(widget.vehicle.size.toString()),
                    style: AppTextStyles.blackFont16Bold
                  ),
                  Text(
                    widget.vehicle.model != null
                        ? widget.vehicle.model.toString()
                        : '',
                    style: AppTextStyles.blackFont12Regular,
                  ),
                  Text(
                    widget.vehicle.registrationNumber != null
                        ? widget.vehicle.registrationNumber.toString()
                        : '',
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 1,),

          ],
        )
    );
  }

  void _handleClickToSeePlans() {
    // Navigator.push(
    //       context, MaterialPageRoute(builder:
    //         (context) => SelectPlanScreen(vehicle: widget.vehicle)));
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.transparent,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: VehicleAddressBottomSheet(vehicle: widget.vehicle,isSubscription: false,time: widget.time,serviceItem: widget.serviceItem,));
      },
    );
  }






  void editVehicle(String? id) async{
    // Navigator.push(
    //     context, MaterialPageRoute(builder:
    //     (context) => UpdateVehicle(vehicle: widget.vehicle)));

    Response response = await RestServiceImp.deleteVehicle(id);
    if(response.isSuccess){
      read.deleteVehicle(id!);
      Navigator.of(context).pop();

    }

  }

  addressBottomSheet() {

    final List<Map<String, String>> addresses = [
      {
        "type": "Home",
        "address": "Flat 203, Shanti Apartment\nNoida - 201301"
      },
      {
        "type": "Work",
        "address": "Tower B, Cyber Park\nGurgaon - 122002"
      }
    ];
    return SafeArea(
      child: Wrap(
        children: [

          const SizedBox(height: 10),

          /// Drag Handle
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Select Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          /// Address List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addresses.length,
            itemBuilder: (context, index) {

              final address = addresses[index];

              return Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [

                    const Icon(Icons.location_on, color: Colors.red),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            address["type"]!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          Text(address["address"]!)
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    )
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// Add Address Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Add New Address"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}