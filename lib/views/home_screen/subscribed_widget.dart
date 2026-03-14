import 'package:car_wash/ApiResponse/subscription_vehicle_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/subscription_vehicle.dart';
import 'package:car_wash/providers/subscription_vehicle_provider.dart';
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/vehicle.dart';
import '../../widgets/subscribed_vehicle_widget.dart';

class SubscribedWidget extends StatefulWidget {
  const SubscribedWidget({super.key});

  @override
  State<SubscribedWidget> createState() => _SubscribedWidget();
}

class _SubscribedWidget extends State<SubscribedWidget> {


  late SubscriptionVehicleProvider read,watch;

  final List<Vehicle> defaultCarList = const [
    Vehicle(
        nickName: 'Hatch Back',
        vehicleType: 'CAR',
        category: 'i.e:alto,i10,i20,etc',
        size: 'HATCHBACK'),
    Vehicle(
        nickName: 'Sedan',
        vehicleType: 'CAR',
        category: 'i.e:ford,toyota,corolla,civic etc',
        size: 'SEDAN'),
  ];


  @override
  void initState() {
    // TODO: implement initState
    read  = context.read<SubscriptionVehicleProvider>();
    Future.microtask((){
      loadSubscriptionVehicles();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<SubscriptionVehicleProvider>();

    return  watch.vehicles.isEmpty?Container(): Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 20),
        const Text(
          'Subscribed',
          style: AppTextStyles.blackFont20Bold,
        ),
        const SizedBox(height: 12),
        subscribedVehicles()
    ]);
  }

  Widget subscribedVehicles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 20),
        // const Text('Saved Vehicles', style: AppTextStyles.whiteFont16Regular,),
        const SizedBox(height: 4),
        ...List.generate(2*watch.vehicles.length, (index){
          if(index.isOdd) return const SizedBox(height: 16);
          return SubscribedVehicleWidget(vehicle: watch.vehicles[index~/2],
            colorTheme: ColorTheme.dark,);

        })
      ],
    );
  }

  Future<void> loadSubscriptionVehicles()async {

    SubscriptionVehicleResponse vehicle = await RestServiceImp.getSubscriptionWithVehicles();

    if(vehicle.isSuccess){
      read.setVehicles(vehicle.data);
    }
  }
}
