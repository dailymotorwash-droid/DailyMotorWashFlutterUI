import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/custom_rich_text.dart';
import 'package:flutter/material.dart';

class CurrentOfferWidget extends StatelessWidget {
  const CurrentOfferWidget({ super.key });

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/ToyCar.png', height: 100, width: 100,),
              const SizedBox(width: 12),
              const Expanded(
                child: CustomRichText(
                  arrayLength: 2, 
                  callBacksInOrder: const [null, null], 
                  textsInOrder: [
                    'Get Complete Car Wash at your Doorstep\n\n',
                   'Full Exterior Body Wash - Internal Cleaning - Polishing'
                  ], 
                  textStylesInOrder: [AppTextStyles.whiteFont12Bold, AppTextStyles.whiteFont12Regular]
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: () {
            
            }, 
            style: AppButtonStyles.primaryButtonStyle,
            child: const Text('Book Now', style: AppTextStyles.whiteFont16Bold)
          )
        ],
      ),
    );
  }
}