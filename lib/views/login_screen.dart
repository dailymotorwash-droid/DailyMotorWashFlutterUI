import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/ApiResponse/user_profile_response.dart';
import 'package:dmw/utils/local_storage.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pinput/pinput.dart';

import 'package:dmw/utils/custom_button_styles.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/views/otp_verification_screen.dart';
import 'package:dmw/widgets/custom_rich_text.dart';
import 'package:dmw/widgets/outlined_text_field.dart';
import 'package:provider/provider.dart';

import '../ApiResponse/LoginResponse.dart';
import '../Apis/RestServiceImp.dart';
import '../providers/user_provider.dart';
import '../utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  final String? code;

  const LoginScreen({super.key,this.code});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _mobileController = TextEditingController();
  bool showReferral = false;
  final TextEditingController _referralController = TextEditingController();
  bool isTermsAccepted = false;

  late UserProvider read,watch;

  @override
  void initState() {
    clearLocalStorage();
    read = context.read<UserProvider>();
    Future.microtask(() async {
      await FirebaseAuth.instance.signOut();
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      bottomNavigationBar: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              // --- BOTTOM TEXT BUTTON ---
              if (!showReferral)
                TextButton(
                  onPressed: () => setState(() => showReferral = true),
                  child: const Text(
                    'Have referral code?',
                    style: AppTextStyles.whiteFont16Regular, // Adjust style as needed
                  ),
                ),
              const SizedBox(height: 16),

              const CustomRichText(
              arrayLength: 3,
              textsInOrder: ['Made with ', 'L❤️ove ', 'for Bharat'],
              textStylesInOrder: [
                AppTextStyles.orangeFont16Regular,
                AppTextStyles.whiteFont16Regular,
                AppTextStyles.greenFont16Regular
              ],
              callBacksInOrder: [null, null, null],
            ),]
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png',height: 120, width: 120),
                  const SizedBox(height: 8),
                  const Text(
                    'SIGNUP / SIGNIN',
                    style: AppTextStyles.whiteFont20Regular,
                  ),
                  const SizedBox(height: 32),
                  OutlinedTextField(
                    hintText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.phone),
                    keyboardType: TextInputType.phone,
                    controller: _mobileController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) => null,
                  ),
                  // --- ADDED REFERRAL FIELD ---
                  if (showReferral) ...[
                    const SizedBox(height: 12),
                    OutlinedTextField(
                      hintText: 'Referral Code (Optional)',
                      prefixIcon: const Icon(Icons.card_giftcard),
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(
                              text: newValue.text.toUpperCase());
                        }),
                      ],
                      controller: _referralController, onChanged: (value) => null,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        semanticLabel: 'Check For Terms and Conditions',
                        activeColor: AppColors.white,
                        checkColor: AppColors.black,
                        fillColor: WidgetStateProperty.all(AppColors.white),
                        overlayColor: WidgetStateProperty.all(AppColors.white),
                        value: isTermsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            isTermsAccepted = !isTermsAccepted;
                          });
                        }
                      ),
                      CustomRichText(
                        arrayLength: 4, 
                        textsInOrder: const [
                          'By continuing, you agree to DMW\'s\n',
                          'terms of use',
                          ' and ',
                          'privacy policy'
                        ], 
                        textStylesInOrder: const [
                          AppTextStyles.whiteFont12Regular,
                          AppTextStyles.whiteUnderlinedFont12Bold,
                          AppTextStyles.whiteFont12Regular,
                          AppTextStyles.whiteUnderlinedFont12Bold
                        ], 
                        callBacksInOrder: [null, () => _handleTermsOFUseClick(context), null, () => _handlePrivacyPolicyClick(context)],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  watch.isLoading? CommonUtils.loader():ElevatedButton(
                    onPressed: (){
                      if (!isTermsAccepted || _mobileController.text.length != 10) {
                        debugPrint('Please Accept Terms and Policy and Enter 10 digits Mobile Number');
                        CommonUtils.toastMessage("Please Accept Terms and Policy and Enter 10 digits Mobile Number");
                        return;
                      }
                      String referralCode = _referralController.text;
                      if(referralCode.isNotEmpty) {
                        read.setIsLoading(true);
                        checkReferralCode(referralCode);
                        return;
                      }
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => OtpVerificationScreen(mobileNumber: _mobileController.text,code: widget.code,)));
                    },
                    style: AppButtonStyles.primaryButtonStyle,
                    child: const Text('Submit', style: AppTextStyles.whiteFont16Bold,)
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }


  static void _handleTermsOFUseClick(BuildContext context) {
    debugPrint('Terms of Use CLicked');
    Navigator.pushNamed(context, AppRoutes.termCondition);

  }
 

  static void _handlePrivacyPolicyClick(BuildContext context) {
    debugPrint("Privacy Policy Clicked");
    Navigator.pushNamed(context, AppRoutes.privacyPolicy);

  }

  Future<void> clearLocalStorage() async {
    var storage = await LocalStorage.getInstance();
    storage.clearSharedPreferences();
  }

  Future<void> checkReferralCode(String referralCode) async{
      UserProfileResponse res = await RestServiceImp.checkReferralCode(
          referralCode);
      read.setIsLoading(false);
      if(res.isSuccess){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(mobileNumber: _mobileController.text,code: referralCode,)));
        return;
      }
      CommonUtils.toastMessage("Invalid referral code");
  }
}
