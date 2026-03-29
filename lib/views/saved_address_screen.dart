import 'package:dmw/ApiResponse/address_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/address.dart';
import 'package:dmw/providers/address_provider.dart';
import 'package:dmw/views/address_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/common_utils.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_text_styles.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  late AddressProvider read, watch;

  @override
  void initState() {
    // TODO: implement initState
    read = context.read<AddressProvider>();
    Future.microtask((){
      loadAddresses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<AddressProvider>();
    return Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          foregroundColor: AppColors.white,
          centerTitle: true,
          title: const Text('Saved Addresses',
              style: AppTextStyles.whiteFont20Regular),
        ),
        body: watch.isLoading
            ? CommonUtils.loader()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                // child:  watch.vehicles.isEmpty?/*defaultVehicles()*/const Center(child: Text("Please Add Address")):vehicles(watch.vehicles)
                child: addresses(watch.addresses)));
  }


  Widget addresses(List<Address> addresses){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 4),
        ...List.generate(2*addresses.length, (index) {
          if(index.isOdd) return const SizedBox(height: 16);
          return addresses.isEmpty?const Center(child: Text("Please Add Address",style:TextStyle(
              color: AppColors.white
          ) ,)):address(addresses[index~/2],);
        }),
      ],
    );
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
                  Text(
                      '${address.houseNo},${address.addressLine1!}'
                          '${address.addressLine2 == null ? '' : ',${address
                          .addressLine2}'}${address.addressLine3 ==null
                          ? ''
                          : ',${address.addressLine3}'}${address.addressLine4 == null? '' : ',${address.addressLine4}'}${address
                          .city!.isEmpty ? '' : ',${address
                          .city}'}'
                          ',${address.district},${address.state}- ${address.pinCode}',
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
            Center(
              child: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.white,
                onPressed: () {
                  // Navigate to edit address
                  Navigator.push(
                      context, MaterialPageRoute(builder:
                      (context) =>
                      AddressScreen(address:address,vehicleId:address.vehicleId!,from: "UPDATE", )));
                },
              ),
            )
          ],
        ),
    );
  }

  Future<void> loadAddresses() async{

    AddressResponse response = await RestServiceImp.getUserAddresses();
    if(response.isSuccess){
      read.setAddresses(response.data);
    }

  }
}
