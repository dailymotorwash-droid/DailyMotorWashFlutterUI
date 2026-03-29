import 'package:dmw/ApiResponse/vehicle_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/providers/vehicle_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehicle.dart';
import '../utils/common_utils.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_enums.dart';
import '../utils/custom_text_styles.dart';
import '../widgets/vehicle_widget.dart';

class AllSavedVehicles extends StatefulWidget{
  const AllSavedVehicles({super.key});

  @override
  @override
  State<AllSavedVehicles> createState() =>
      _AllSavedVehicles();

}

class _AllSavedVehicles extends State<AllSavedVehicles>{


  late VehicleProvider read,watch;

  @override
  void initState() {
    // TODO: implement initState
    read = context.read<VehicleProvider>();

    Future.microtask((){
      read.setIsLoading(true);
      loadVehicles();


    });

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    watch = context.watch<VehicleProvider>();
    return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.white,
          centerTitle: true,
          title: const Text('Saved Vehicles', style: AppTextStyles.whiteFont20Regular),
        ),
        body: watch.isLoading?CommonUtils.loader():SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            // child:  watch.vehicles.isEmpty?/*defaultVehicles()*/const Center(child: Text("Please Add Address")):vehicles(watch.vehicles)
            child: vehicles(watch.vehicles)
        )
    );
  }

  Widget vehicles(List<Vehicle> vehicles){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 4),
        ...List.generate(2*vehicles.length, (index) {
          if(index.isOdd) return const SizedBox(height: 16);
          return vehicles.isEmpty?const Center(child: Text("Please Add Vehicle",style:TextStyle(
              color: AppColors.white
          ) ,)):VehicleWidget(
            vehicle: vehicles[index~/2],
            colorTheme: ColorTheme.dark,
            isEditable: true,
          );
        }),
      ],
    );
  }

  Future<void> loadVehicles() async {
    VehicleResponse response = await RestServiceImp.getAllVehicles();
    if(response.isSuccess){
      read.setIsLoading(false);
      read.setVehicles(response.data);
      return;
    }

    CommonUtils.toastMessage(response.message);


  }


}