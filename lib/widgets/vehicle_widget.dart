import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/vehicle.dart';
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

class VehicleWidget extends StatefulWidget {

  final bool isEditable;
  final Vehicle vehicle;
  final bool isClickable;
  final ColorTheme colorTheme;

  const VehicleWidget({ 
    super.key,
    this.isClickable = true,
    this.colorTheme = ColorTheme.light,
    required this.vehicle, required this.isEditable,
  });

  @override
  State<VehicleWidget> createState() => _VehicleWidgetState();
}

class _VehicleWidgetState extends State<VehicleWidget> {

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
    return widget.isEditable?editableVehicles():InkWell(
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

  Widget editableVehicles(){

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: widget.colorTheme == ColorTheme.light
              ? AppColors.white
              : AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.colorTheme == ColorTheme.light
                  ? AppColors.secondary
                  : AppColors.black,
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 2),
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
                    style: widget.colorTheme == ColorTheme.light
                        ? AppTextStyles.blackFont16Bold
                        : AppTextStyles.whiteFont16Bold,
                  ),
                  Text(
                    widget.vehicle.model != null
                        ? widget.vehicle.model.toString()
                        : '',
                    style: widget.colorTheme == ColorTheme.light
                        ? AppTextStyles.blackFont12Regular
                        : AppTextStyles.whiteFont12Regular,
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

            IconButton(
              icon: Icon(
                Icons.delete,
                color: widget.colorTheme == ColorTheme.light
                    ? Colors.black
                    : Colors.white,
              ),
              onPressed: () {
                // Edit action
                _showDeleteConfirmation(context,widget.vehicle.id!);
              },
            ),
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
            child: VehicleAddressBottomSheet(vehicle: widget.vehicle));
      },
    );
  }






  void _showDeleteConfirmation(BuildContext context, String vehicleId) {
    if (subWatch.isVehiclePresent(vehicleId)) {
      print("Error: Vehicle already exists in the system!");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2A313B), // Matches your dark theme
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text(
              "Error",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              "You can not delete if subscription is active",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Okay", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
      return; // Stop here
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A313B), // Matches your dark theme
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Confirm Delete",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to remove this vehicle? This action cannot be undone.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Closes the popup
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.white38),
              ),
            ),
            // Delete Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {

                editVehicle(vehicleId);
                // 3. Optional: Show a snackbar confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Vehicle deleted")),
                );
              },
              child: const Text("DELETE", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
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