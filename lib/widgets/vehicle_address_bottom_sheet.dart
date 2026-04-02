import 'package:dmw/ApiResponse/address_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/vehicle.dart';
import 'package:dmw/providers/address_provider.dart';
import 'package:dmw/providers/vehicle_provider.dart';
import 'package:dmw/utils/common_utils.dart';
import 'package:dmw/views/address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../utils/custom_button_styles.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_text_styles.dart';
import '../views/select_plan_screen.dart/select_plan_screen.dart';

class VehicleAddressBottomSheet extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleAddressBottomSheet({
    super.key,
    required this.vehicle,
  });

  @override
  State<VehicleAddressBottomSheet> createState() =>
      _VehicleAddressBottomSheet();
}

class _VehicleAddressBottomSheet extends State<VehicleAddressBottomSheet> {

  late AddressProvider read,watch;
  late Vehicle _vehicle;

  @override
  void initState() {
    // TODO: implement initState
    _vehicle = widget.vehicle;
    read = context.read<AddressProvider>();
    Future.microtask((){
      read.setIsLoading(true);
      loadAddresses();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    watch = context.watch<AddressProvider>();
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

          const SizedBox(height: 40),

          /// Address List
          watch.isLoading?CommonUtils.loader():ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: watch.addresses.length,
            itemBuilder: (context, index) {
              final addresses= watch.addresses[index];
              return InkWell(
                onTap: (){
                  Navigator.push(
                        context, MaterialPageRoute(builder:
                          (context) => SelectPlanScreen(vehicle: _vehicle,address:addresses)));
                },
                  child: address(addresses));

              // return Container(
              //   padding: const EdgeInsets.all(14),
              //   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.2),
              //         blurRadius: 5,
              //         offset: const Offset(0, 2),
              //       )
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       const Icon(Icons.location_on, color: Colors.red),
              //       const SizedBox(width: 12),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               address["type"]!,
              //               style: const TextStyle(fontWeight: FontWeight.bold),
              //             ),
              //             const SizedBox(height: 4),
              //             Text(address["address"]!)
              //           ],
              //         ),
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.edit),
              //         onPressed: () {},
              //       )
              //     ],
              //   ),
              // );
            },
          ),

          const SizedBox(height: 20),

          /// Add Address Button

          Center(
            child: GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, AppRoutes.addVehicleScreen);
                Navigator.push(
                    context, MaterialPageRoute(builder:
                    (context) => AddressScreen(vehicleId:_vehicle.id!,from: "ADD",)));
              },
              child: const Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
            
                children: [
                  Icon(Icons.add_circle_rounded, color: AppColors.primary,),
                  SizedBox(width: 8),
                  Text('Add Address', style: AppTextStyles.primaryFont16Bold,)
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: SizedBox(
          //     width: double.infinity,
          //     height: 48,
          //     child: ElevatedButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context, MaterialPageRoute(builder:
          //             (context) =>  AddressScreen(vehicleId:_vehicle.id!,from: "ADD",)));
          //       },
          //       style: AppButtonStyles.primaryButtonStyle,
          //       child: const Text("Add New Address",style: AppTextStyles.whiteFont16Bold,),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> loadAddresses() async{

    AddressResponse response = await RestServiceImp.getUserAddressesByVehicleId(_vehicle.id!);
    if(response.isSuccess){
      read.setIsLoading(false);
      read.setAddresses(response.data);
    }

  }

  Widget address(Address address) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary,
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
          /// Address Icon
          const Icon(Icons.location_on, size: 40, color: Colors.red),

          const SizedBox(width: 16),

          /// Address Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    address.addressLine1!,
                    style: AppTextStyles.whiteFont16Bold
                ),
                const SizedBox(height: 4),
                Text(getFormattedAdd(address),
                  style: AppTextStyles.whiteFont12Regular,
                ),
                // Text(
                //   "Sector 62, Noida, Uttar Pradesh - 201301",
                //   style: TextStyle(fontSize: 14),
                // ),
              ],
            ),
          ),

          /// Edit Button
          // Center(
          //   child: IconButton(
          //     icon: const Icon(Icons.edit),
          //     color: Colors.white,
          //     onPressed: () {
          //       // Navigate to edit address
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
  String getFormattedAdd(Address? address) {
    if (address == null) return '';

    // Filter out empty or null strings to avoid double commas like ", ,"
    final parts = [
      address.houseNo,
      address.addressLine1,
      address.addressLine2,
      address.addressLine3,
      address.addressLine4,
      address.city,
      address.district,
      address.state,
    ].where((s) => s != null && s.isNotEmpty).toList();

    String base = parts.join(', ');

    // Add PinCode with the specific dash formatting
    if (address.pinCode != null && address.pinCode!.isNotEmpty) {
      base += ' - ${address.pinCode}';
    }

    return base;
  }

}
