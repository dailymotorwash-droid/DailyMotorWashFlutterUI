import 'package:car_wash/ApiResponse/vehicle_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/providers/vehicle_provider.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/local_storage.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/vehicle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ApiResponse/user_profile_response.dart';
import '../widgets/default_vehicle.dart';
import 'add_vehicle_and_address.dart';

class SavedVehiclesScreen extends StatefulWidget {

  final VehicleType? vehicleType;

  const SavedVehiclesScreen({
    super.key,
    required this.vehicleType,
  });

  @override
  State<SavedVehiclesScreen> createState() => _SavedVehiclesScreenState();
}

class _SavedVehiclesScreenState extends State<SavedVehiclesScreen> {

  late VehicleProvider read,watch;

  // final List<Vehicle> vehicleList = const [
  //   Vehicle(model: 'Seltos', brand: 'KIA', category: 'Mini SUV', vehicleType: 'Car', registrationNumber: 'DL!RS456',),
  //   Vehicle(model: 'AMG', brand: 'Mercedes', category: 'Luxury', vehicleType: 'Car', registrationNumber: 'DL!RS456'),
  //   Vehicle(model: 'Bajaj', brand: 'Pulsar', category: 'Daily Use', vehicleType: 'Bike', registrationNumber: 'DL!RS456'),
  // ];

  final List<Vehicle> defaultCarList = const [
    Vehicle( nickName: 'Hatch Back', vehicleType: 'CAR',category: 'i.e:alto,i10,i20,etc',size: 'HATCHBACK'),
    Vehicle( nickName: 'Sedan', vehicleType: 'CAR',category: 'i.e:ford,toyota,corolla,civic etc',size: 'SEDAN'),
    Vehicle( nickName: 'Luxury', vehicleType: 'CAR',category: 'i.e:BMW,Audi,Mercedes,etc',size: 'LUXURY'),
    Vehicle( nickName: 'Mid Suv', vehicleType: 'CAR',category: 'i.e:Thar,Seltos,creta,etc',size: 'COMPACT_SUV'),
    Vehicle( nickName: 'SUV', vehicleType: 'CAR',category: 'i.e:Kia carnival,fortuner,tata hexa,etc',size: 'SUV'),

  ];

  late VehicleType _vehicleType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vehicleType = widget.vehicleType!;
    read = context.read<VehicleProvider>();
    Future.microtask(() {
      read.setIsLoading(true);
        loadVehicles();
    });

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
        title: const Text('Select Your Vehicle', style: AppTextStyles.whiteFont20Regular),
      ),
      body: watch.isLoading?CommonUtils.loader():SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // child:  watch.vehicles.isEmpty?/*defaultVehicles()*/const Center(child: Text("Please Add Address")):vehicles(watch.vehicles)
        child: vehicles(watch.vehicles)
      )
    );
  }

  Future<void> loadVehicles() async {
    var storage = await LocalStorage.getInstance();
    VehicleResponse response =  await RestServiceImp.getUserVehicles(storage.getToken(),_vehicleType.label);
    if (response.isSuccess) {
      read.setVehicles(response.data);
      read.setIsLoading(false);
    }
  }

  Widget vehicles(List<Vehicle> vehicles){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, AppRoutes.addVehicleScreen);
            Navigator.push(
                          context, MaterialPageRoute(builder:
                          (context) => AddVehicleAndAddressScreen(vehicleType:_vehicleType)));
          },
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_rounded, color: AppColors.primary,),
              SizedBox(width: 8),
              Text('Add Vehicle', style: AppTextStyles.primaryFont16Bold,)
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(vehicles.isEmpty?'':'Saved Vehicles', style: AppTextStyles.whiteFont16Regular,),
        const SizedBox(height: 4),
        ...List.generate(2*vehicles.length, (index) {
          if(index.isOdd) return const SizedBox(height: 16);
          return vehicles.isEmpty?const Center(child: Text("Please Add Vehicle",style:TextStyle(
            color: AppColors.white
          ) ,)):VehicleWidget(
            vehicle: vehicles[index~/2],
            colorTheme: ColorTheme.dark,
          );
        }),
      ],
    );
  }
  Widget defaultVehicles(){

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // const Text('Saved Vehicles', style: AppTextStyles.whiteFont16Regular,),
        const SizedBox(height: 4),
        ...List.generate(2*defaultCarList.length, (index) {
          if(index.isOdd) return const SizedBox(height: 16);
          return DefaultVehicleWidget(
            vehicle: defaultCarList[index~/2],
            colorTheme: ColorTheme.dark,
          );
        }),
      ],
    );
  }

  // Future<void> validate() async {
  //   // userRead.setIsLoading(true);
  //   var storage = await LocalStorage.getInstance();
  //   UserProfileResponse user = await RestServiceImp.getProfile(storage.getToken()!);
  //   // userRead.setIsLoading(false);
  //   if(user.isSuccess){
  //     print(user.data.status==ProfileStatus.pending.label);
  //     print('${user.data.status!}:${ProfileStatus.pending.label}:');
  //     if(user.data.status==ProfileStatus.pending.label){
  //       Navigator.push(
  //           context, MaterialPageRoute(builder:
  //           (context) => ProfileScreen(user: user.data,)));
  //     }else{
  //       AddressResponse addRes = await RestServiceImp.getUserAddresses(storage.getToken());
  //       if(addRes.isSuccess){
  //         if(addRes.data.isEmpty){
  //
  //         }
  //       }
  //     }
  //   }
  // }

}