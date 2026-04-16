import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/utils/common_utils.dart';
import 'package:dmw/utils/custom_button_styles.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../ApiResponse/Response.dart';
import '../../ApiResponse/referral_code_response.dart';

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
              getReferralLink();
            }, 
            style: AppButtonStyles.primaryButtonStyle,
            child: const Text('Refer Now', style: AppTextStyles.whiteFont12Bold,),
          )
          
        ],
      ),
    );
  }

  Future<void> getReferralLink() async{

    ReferralCodeResponse res = await RestServiceImp.getReferralLink();
    if(res.isSuccess){
      shareReferral(res.data);
    }else{
      CommonUtils.toastMessage("Something went wrong");
    }

  }
  void shareReferral(String link) {

// Parse the string into a Uri object
    Uri uri = Uri.parse(link);
// Extract the 'code' parameter
    String? referralCode = uri.queryParameters['code'];
    print(referralCode);
    SharePlus.instance.share(
      ShareParams(
        text: "Join Daily Wash using my link:\n$link \n \n Code:${referralCode?.toUpperCase()}",
      ),
    );
  }
}