import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/views/saved_vehicles_screen.dart';
import 'package:flutter/material.dart';

class DoorstepWashWidget extends StatelessWidget {
  const DoorstepWashWidget({ super.key });

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Doorstep Wash', style: AppTextStyles.blackFont20Bold,),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (index) {
              if(index.isOdd) return const SizedBox(width: 12);
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if(index == 0) {
                      Navigator.push(
                        context, MaterialPageRoute(builder:
                          (context) => const SavedVehiclesScreen(vehicleType: VehicleType.car,),));
                    } else {
                      Navigator.push(
                        context, MaterialPageRoute(builder:
                          (context) => const SavedVehiclesScreen(vehicleType: VehicleType.twoWheeler,),));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                         BoxShadow (
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [ 
                        Image.asset('assets/images/ToyCar.png', width: 80, height: 80,),
                        const SizedBox(height: 8),
                        Text(index == 0 ? 'Car Wash' : 'Bike Wash', style: AppTextStyles.blackFont16Bold,)
                      ],
                    ),
                  ),
                ),
              );
            }),
          )

        ],
      ),
    );
  }
}