import 'dart:async';
import 'package:dmw/ApiResponse/LoginResponse.dart';
import 'package:dmw/ApiResponse/VerifyOTPResponse.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/log_in.dart';
import 'package:dmw/models/user.dart';
import 'package:dmw/providers/user_provider.dart';
import 'package:dmw/utils/custom_button_styles.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:pinput/pinput.dart';

import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:provider/provider.dart';

import '../ApiResponse/Response.dart';
import '../utils/common_utils.dart';
import '../utils/local_storage.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final String? code;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    this.code
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  final Logger logger = Logger(); 
  final TextEditingController _otpController = TextEditingController();

  late UserProvider userProviderWatch,userProviderRead;
  late bool _isWaitTimerRunning;
  Timer? _resendOTPTimer;
  late int _remainingSeconds;
  late int _remainingMin;
  late String _phone;
  late bool isLoading = false;
  late String _verificationId;
  @override
  void initState() {
    _phone = widget.mobileNumber;
    Future.microtask((){
      _sendOtp();
    });
    userProviderRead = context.read<UserProvider>();
    _startResendWaitTimer();
    super.initState();
  }

  @override
  void dispose() {
    _resendOTPTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userProviderWatch = context.watch<UserProvider>();
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
                  onPressed: _isWaitTimerRunning?null: () => _verifyPhone(),
                  child: Text(
                    _isWaitTimerRunning ? '0$_remainingMin:${_remainingSeconds > 9 ? '$_remainingSeconds' : '0$_remainingSeconds'}' : 'Resend OTP',
                    style: AppTextStyles.whiteFont16Regular
                  ),
                ),
              ),
              const SizedBox(height: 8),
              userProviderWatch.isLoading? CommonUtils.loader():ElevatedButton(
                onPressed: _signInWithOTP,
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
      String? userState = userProviderWatch.user?.state;
      LogInResponse res  = await RestServiceImp.auth(_phone, '123456',widget.code);
      if (res.isSuccess) {
        LocalStorage.setToken(res.data.token!);
        LocalStorage.setFirstName(res.data.firstName!);
        LocalStorage.setLastName(res.data.lastName!);
        LocalStorage.setUserId(res.data.id!);
        LocalStorage.setStatus(res.data.status!);
        userProviderRead.login(User(firstName:res.data.firstName,lastName:res.data.lastName,phone: widget.mobileNumber,state: 'registered_user'));
        debugPrint(userState);
        userProviderRead.setIsLoading(false);

        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeScreen,(Route<dynamic> route) => false);
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
    // Safe cancel: If it's null, nothing happens. If it exists, it stops.
    _resendOTPTimer?.cancel();

    int totalSeconds = 60;

    setState(() {
      _remainingMin = 1;
      _remainingSeconds = 0;
      _isWaitTimerRunning = true;
    });

    _resendOTPTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalSeconds > 0) {
        totalSeconds--;
        if (mounted) { // Good practice: check if screen is still open
          setState(() {
            _remainingMin = totalSeconds ~/ 60;
            _remainingSeconds = totalSeconds % 60;
          });
        }
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _resendOTPTimer?.cancel();
    if (mounted) {
      setState(() {
        _isWaitTimerRunning = false;
      });
    }
  }
  void _signInWithOTP() async {
    userProviderRead.setIsLoading(true);
    String smsCode = _otpController.text;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      // User is now signed in!
      await _handleOTPSubmission();

    } on FirebaseAuthException catch (e) {
      // Specifically handle Firebase errors (like expired codes)
      debugPrint("Firebase Auth Error: ${e.code}");
      userProviderRead.setIsLoading(false);
      CommonUtils.toastMessage("Invalid or expired OTP");
    } catch (e) {
      debugPrint("General Error: $e");
    }
  }

  void _verifyPhone() async {
    _startResendWaitTimer();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$_phone', // Format: +919876543210
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY: Automatic SMS handling
        if (credential.smsCode != null) {
          _otpController.text = credential.smsCode!;
        }
        await FirebaseAuth.instance.signInWithCredential(credential);
        _handleOTPSubmission();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
        print("Verification Failed: ${e.phoneNumber}");
        CommonUtils.toastMessage(e.message!);
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save this ID to use when the user enters the OTP
        _verificationId = verificationId;
        // Navigate to your OTP screen here
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _handleLoginSubmit() async {
    debugPrint(_phone);
    String phone = _phone;
    Response logInResponse = await RestServiceImp.otpSend(phone);
    print(logInResponse.isSuccess);
    if(logInResponse.isSuccess) {
      
    }else{
      CommonUtils.toastMessage("Something went wrong");

    }
  }

  void _sendOtp() async {

    String phoneNumber = _phone;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber', // Format: +919876543210
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY: Automatic SMS handling
        await FirebaseAuth.instance.signInWithCredential(credential);
        _handleOTPSubmission();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
        print("Verification Failed: ${e.phoneNumber}");
        CommonUtils.toastMessage(e.message!);

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
}
