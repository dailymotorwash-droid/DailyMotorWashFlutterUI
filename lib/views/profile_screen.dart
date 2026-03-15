import 'package:car_wash/ApiResponse/user_profile_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/user.dart';
import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';

import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/custom_button_styles.dart';
import '../utils/custom_enums.dart';
import '../utils/local_storage.dart';

class ProfileScreen extends StatefulWidget {
  // final User user;
  const ProfileScreen({
    super.key,
    // required this.user
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emaddilController = TextEditingController();

  late String? _firstNameFieldErrorText =
      'Minimum 3 characters (letters & spaces only)';

  // late String? _lastNameFieldErrorText = 'Minimum 3 characters (letters & spaces only)';
  // late String? _emailFieldErrorText = 'Invalid email format';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedGender;
  late User user;

  late UserProvider read, watch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // user = widget.user;
    read = context.read<UserProvider>();

    Future.microtask(() {
      loadUserData();
    });
    // _firstNameController.text = user.firstName!;
    // _lastNameController.text = user.lastName!;
    // _emailController.text = user.email!;
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<UserProvider>();
    if (watch.user != null) {
      _firstNameController.text = watch.user!.firstName!;
      _lastNameController.text = watch.user!.lastName!;
      _emailController.text = watch.user!.email!;
      _emaddilController.text = watch.user!.email!;

      if (watch.user!.gender != null) {
        _selectedGender = watch.user?.gender;
      }
    }

    return Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.black,
          centerTitle: true,
          title: const Text(
            'Profile',
            style: AppTextStyles.blackFont20Regular,
          ),
        ),
        // floatingActionButton: _firstNameFieldErrorText != null || _emailFieldErrorText != null
        // ? FloatingActionButton(
        //   onPressed: _handleProfileSubmit,
        //   backgroundColor: AppColors.darkBackground,
        //   foregroundColor: AppColors.lightBackground,
        //   child: const Icon(Icons.arrow_forward_rounded),
        // ) : null,
        body: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const CircleAvatar(radius: 75),
              const SizedBox(height: 40),
              Row(
                children: [
                  /// FIRST NAME DROPDOWN
                  Expanded(
                      child: UnderlinedTextField(
                    colorTheme: ColorTheme.light,
                    labelText: "First Name",
                    controller: _firstNameController,
                    onChanged: (v) {},
                  )),

                  const SizedBox(width: 16),

                  /// LAST NAME
                  Expanded(
                    child: UnderlinedTextField(
                      colorTheme: ColorTheme.light,
                      labelText: "Last Name",
                      controller: _lastNameController,
                      onChanged: (v) {},
                    ),
                  ),
                ],
              ),
              // UnderlinedTextField(
              //   controller: _firstNameController,
              //   labelText: 'First Name',
              //   prefixIcon: const Icon(Icons.person),
              //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),],
              //   errorText: _firstNameFieldErrorText,
              //   onChanged: (value) {
              //     String? newErrorText;
              //     if (value == null || value.isEmpty) {
              //       newErrorText = 'Minimum 3 characters(letters & spaces only)';
              //     } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
              //       newErrorText = 'Only letters and spaces are allowed';
              //     }
              //     setState(() {
              //       _firstNameFieldErrorText = newErrorText;
              //     });
              //   },
              // ),
              // const SizedBox(height: 40),
              // UnderlinedTextField(
              //   controller: _lastNameController,
              //   labelText: 'Last Name',
              //   prefixIcon: const Icon(Icons.person),
              //   inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),],
              //   errorText: _lastNameFieldErrorText,
              //   onChanged: (value) {
              //     String? newErrorText;
              //     if (value == null || value.isEmpty) {
              //       newErrorText = 'Minimum 3 characters(letters & spaces only)';
              //     } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
              //       newErrorText = 'Only letters and spaces are allowed';
              //     }
              //     setState(() {
              //       _lastNameFieldErrorText = newErrorText;
              //     });
              //   },
              // ),

              const SizedBox(height: 16),

              UnderlinedTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: const Icon(Icons.mail),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                ],
                // errorText: _emailFieldErrorText,
                onChanged: (value) {
                  String? newErrorText;
                  if (value == null || value.isEmpty) {
                  } else if (!RegExp(
                          r'^[a-zA-Z0-9._%±]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    // newErrorText = 'Invalid email format';
                  }
                  // setState(() {
                  //   _emailFieldErrorText = newErrorText;
                  // });
                },
              ),
              const SizedBox(height: 16),
              UnderlinedTextField(
                isFieldEnabled: false,
                initialValue: watch.user?.phone,
                labelText: 'Mobile Number',
                controller: TextEditingController(text: watch.user?.phone),
                prefixIcon: const Icon(Icons.phone),
                onChanged: (value) => null,
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gender",
                  style: AppTextStyles.blackFont16Regular,
                ),
              ),

              Row(
                children: [
                  Radio<String>(
                    value: "MALE",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text("Male"),
                  Radio<String>(
                    value: "FEMALE",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text("Female"),
                  Radio<String>(
                    value: "OTHER",
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const Text("Other"),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: AppButtonStyles.primaryButtonStyle,
                onPressed: () {
                  // Save action
                  _handleProfileSubmit();
                },
                child: const Text("Save",style: AppTextStyles.whiteFont16Bold,),
              ),
            ),
          ),
        ));
  }

  Future<void> _handleProfileSubmit() async {
    if(_firstNameController.text.isEmpty){
      CommonUtils.toastMessage("First Name mandatory(*) ");
      return;
    }
    if(_emailController.text.isNotEmpty&&!RegExp(
    r'^[a-zA-Z0-9._%±]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$').hasMatch(_emailController.text)){
      CommonUtils.toastMessage("Invalid email format");
      return;
    }
    User user = User(
        id: watch.user?.id,
        phone: watch.user!.phone,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender,
        email: _emailController.text,
        state: 'verified_user');
    print(user.toJson());
    UserProfileResponse userProfileResponse = await RestServiceImp.editProfile(user);
    if(userProfileResponse.isSuccess){
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.homeScreen, (route) => false);
      return;
    }
    CommonUtils.toastMessage(userProfileResponse.message);

  }

  Future<void> loadUserData() async {
    UserProfileResponse userProfileResponse = await RestServiceImp.getProfile();
    if (userProfileResponse.isSuccess) {
      read.login(userProfileResponse.data);
      LocalStorage.setFirstName(userProfileResponse.data.firstName!);
      LocalStorage.setLastName(userProfileResponse.data.lastName!);
      LocalStorage.setStatus(userProfileResponse.data.status!);

      return;
    }
    CommonUtils.toastMessage(userProfileResponse.message);
  }
}
