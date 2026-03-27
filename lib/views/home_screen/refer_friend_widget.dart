import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:flutter/material.dart';

class ReferFriendWidget extends StatelessWidget {
  const ReferFriendWidget({ super.key });

  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text('REFER A FRIEND', style: AppTextStyles.whiteFont20Bold),
          // const SizedBox(height: 8),
          Image.asset('assets/images/referral.png', height: 200, width: 300),
          // const SizedBox(height: 8),
          const Text('Get ₹100 Voucher', style: AppTextStyles.primaryFont20Regular),
          // const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {

            }, 
            style: AppButtonStyles.primaryButtonStyle,
            child: const Text('Refer Now', style: AppTextStyles.whiteFont12Bold,),
          )
          
        ],
      ),
    );
  }
}