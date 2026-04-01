import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/utils/local_storage.dart';
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
          child: const CustomRichText(
            arrayLength: 3,
            textsInOrder: ['Made with ', 'L❤️ove ', 'for Bharat'],
            textStylesInOrder: [
              AppTextStyles.orangeFont16Regular,
              AppTextStyles.whiteFont16Regular,
              AppTextStyles.greenFont16Regular
            ],
            callBacksInOrder: [null, null, null],
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
                      const CustomRichText(
                        arrayLength: 4, 
                        textsInOrder: [
                          'By continuing, you agree to honc\'s\n',
                          'terms of use',
                          ' and ',
                          'privacy policy'
                        ], 
                        textStylesInOrder: [
                          AppTextStyles.whiteFont12Regular,
                          AppTextStyles.whiteUnderlinedFont12Bold,
                          AppTextStyles.whiteFont12Regular,
                          AppTextStyles.whiteUnderlinedFont12Bold
                        ], 
                        callBacksInOrder: [null, _handleTermsOFUseClick, null, _handlePrivacyPolicyClick],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  watch.isLoading? CommonUtils.loader():ElevatedButton(
                    onPressed: _verifyPhone,
                    style: AppButtonStyles.primaryButtonStyle,
                    child: const Text('Submit', style: AppTextStyles.whiteFont16Bold,)
                  )
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<void> _handleLoginSubmit() async {
    debugPrint(_mobileController.text);
    String phone = _mobileController.text;
      Response logInResponse = await RestServiceImp.otpSend(phone);
      print(logInResponse.isSuccess);
      if(logInResponse.isSuccess) {
        read.setIsLoading(false);
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(mobileNumber: phone,verificationId: _verificationId,)));

      }else{
        CommonUtils.toastMessage("Something went wrong");

      }
  }
  String _verificationId = "";

  void _verifyPhone() async {

    String phoneNumber = _mobileController.text;
    if (!isTermsAccepted || phoneNumber.length != 10) {
      debugPrint('Please Accept Terms and Policy and Enter 10 digits Mobile Number');
      CommonUtils.toastMessage("Please Accept Terms and Policy and Enter 10 digits Mobile Number");
      return;
    }
    read.setIsLoading(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber', // Format: +919876543210
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY: Automatic SMS handling
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
        print("Verification Failed: ${e.phoneNumber}");
        CommonUtils.toastMessage(e.message!);
        read.setIsLoading(false);

      },
      codeSent: (String verificationId, int? resendToken) {
        // Save this ID to use when the user enters the OTP
        _verificationId = verificationId;
        // Navigate to your OTP screen here
        _handleLoginSubmit();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }
  static void _handleTermsOFUseClick() {
    debugPrint('Terms of Use CLicked');
  }
 

  static void _handlePrivacyPolicyClick() {
    debugPrint("Privacy Policy Clicked");
  }

  Future<void> clearLocalStorage() async {
    var storage = await LocalStorage.getInstance();
    storage.clearSharedPreferences();
  }
}
