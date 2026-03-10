import 'package:car_wash/models/user.dart';
import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';

import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final TextEditingController _emailController = TextEditingController();

  late UserProvider userProvider;
  late String? _firstNameFieldErrorText = 'Minimum 3 characters (letters & spaces only)';
  late String? _lastNameFieldErrorText = 'Minimum 3 characters (letters & spaces only)';
  late String? _emailFieldErrorText = 'Invalid email format';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

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
      floatingActionButton: _firstNameFieldErrorText != null && _emailFieldErrorText != null
      ? FloatingActionButton(
        onPressed: _handleProfileSubmit,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.lightBackground,
        child: const Icon(Icons.arrow_forward_rounded),
      ) : null,
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
            UnderlinedTextField(
              controller: _firstNameController,
              labelText: 'First Name',
              prefixIcon: const Icon(Icons.person),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),],
              errorText: _firstNameFieldErrorText,
              onChanged: (value) {
                String? newErrorText;
                if (value == null || value.isEmpty) {
                  newErrorText = 'Minimum 3 characters(letters & spaces only)';
                } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                  newErrorText = 'Only letters and spaces are allowed';
                }
                setState(() {
                  _firstNameFieldErrorText = newErrorText;
                });
              },
            ),
            const SizedBox(height: 40),
            UnderlinedTextField(
              controller: _lastNameController,
              labelText: 'Last Name',
              prefixIcon: const Icon(Icons.person),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),],
              errorText: _lastNameFieldErrorText,
              onChanged: (value) {
                String? newErrorText;
                if (value == null || value.isEmpty) {
                  newErrorText = 'Minimum 3 characters(letters & spaces only)';
                } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(value)) {
                  newErrorText = 'Only letters and spaces are allowed';
                }
                setState(() {
                  _lastNameFieldErrorText = newErrorText;
                });
              },
            ),

            const SizedBox(height: 16),
            UnderlinedTextField(
              controller: _emailController,
              labelText: 'Email',
              prefixIcon: const Icon(Icons.mail),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9@._-]*$')),],
              errorText: _emailFieldErrorText,
              onChanged: (value) {
                String? newErrorText;
                if (value == null || value.isEmpty) {
                  newErrorText = 'Must Enter Email';
                } else if (!RegExp(r'^[a-zA-Z0-9._%±]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$').hasMatch(value)) {
                  newErrorText = 'Invalid email format';
                }

                setState(() {
                  _emailFieldErrorText = newErrorText;
                });
              },
            ),
            const SizedBox(height: 16),
            UnderlinedTextField(
              isFieldEnabled: false,
              labelText: 'Mobile Number',
              controller: TextEditingController(text: userProvider.user?.phoneNumber),
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
                  value: "Male",
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text("Male"),

                Radio<String>(
                  value: "Female",
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text("Female"),

                Radio<String>(
                  value: "Other",
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
    );
  }

  void _handleProfileSubmit() {
    User newuser = User(
      phoneNumber: userProvider.user!.phoneNumber,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      gender: _selectedGender,
      email: _emailController.text,
      state: 'verified_user'
    );
    userProvider.updateUser(newuser);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.landingScreen, (route) => false);
  }
}
