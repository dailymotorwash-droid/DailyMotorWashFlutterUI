import 'dart:async';
import 'package:car_wash/ApiResponse/LoginResponse.dart';
import 'package:car_wash/ApiResponse/VerifyOTPResponse.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/log_in.dart';
import 'package:car_wash/models/user.dart';
import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:pinput/pinput.dart';

import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:provider/provider.dart';

import '../ApiResponse/Response.dart';
import '../utils/common_utils.dart';
import '../utils/local_storage.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final Logger logger = Logger(); 
  final TextEditingController _otpController = TextEditingController();

  late UserProvider userProvider; 
  late bool _isWaitTimerRunning;
  late Timer _resendOTPTimer;
  late int _remainingSeconds;
  late String _phone;

  @override
  void initState() {
    _phone = widget.mobileNumber;
    _startResendWaitTimer();
    super.initState();
  }

  @override
  void dispose() {
    _resendOTPTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: const Text('OTP Verification', style: AppTextStyles.whiteFont20Regular,),
      ),
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
        alignment: Alignment.center,
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Enter the OTP sent on', style: AppTextStyles.whiteFont16Regular, textAlign: TextAlign.center,),
              const SizedBox(height: 8),
              Text(widget.mobileNumber, style: AppTextStyles.whiteFont16Bold, textAlign: TextAlign.center,),
              const SizedBox(height: 16),
              Pinput(
                length: 6,
                controller: _otpController,
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isWaitTimerRunning?null: () => resendOtp(_phone),
                  child: Text(
                    _isWaitTimerRunning ? '00:${_remainingSeconds > 9 ? '$_remainingSeconds' : '0$_remainingSeconds'}' : 'Resend OTP', 
                    style: AppTextStyles.whiteFont16Regular
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _handleOTPSubmission, 
                style: AppButtonStyles.primaryButtonStyle,
                child: const Text('Submit', style: AppTextStyles.whiteFont16Bold,)
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleOTPSubmission() async {
    debugPrint("${_otpController.text}:$_phone");
    String otp = _otpController.text;

    if(otp.length == 6) {
      String? userState = userProvider.user?.state;
      LogInResponse res  = await RestServiceImp.auth(_phone, otp);
      if (res.isSuccess) {
        LocalStorage.setToken(res.data.token!);
        LocalStorage.setFirstName(res.data.firstName!);
        LocalStorage.setLastName(res.data.lastName!);
        LocalStorage.setUserId(res.data.id!);
        LocalStorage.setStatus(res.data.status!);
        userProvider.login(User(firstName:res.data.firstName,lastName:res.data.lastName,phone: widget.mobileNumber,state: 'registered_user'));
        debugPrint(userState);
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      }else{
        CommonUtils.toastMessage("Incorrect OTP");

      }


      // if(userState == 'registered_user') {
      //   Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
      // } else {
      //   Navigator.pushNamed(context, AppRoutes.profileScreen);
      // }
    } else {
      logger.e('Incorrect OTP');
      CommonUtils.toastMessage("Incorrect OTP");


    }
  }

  Future<void> resendOtp(String phone) async {
    Response logInResponse = await RestServiceImp.otpSend(phone);
    print(logInResponse.isSuccess);
    if(logInResponse.isSuccess) {
      _startResendWaitTimer();
    }else{
      CommonUtils.toastMessage("Something went wrong");

    }
  }
  void _startResendWaitTimer() {

    setState(() {
      _remainingSeconds = 30;
      _isWaitTimerRunning = true;
    });

    _resendOTPTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_remainingSeconds > 1) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _isWaitTimerRunning = false;
          _resendOTPTimer.cancel();
        });
      }
    });
  }
}
