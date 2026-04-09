import 'package:dmw/ApiResponse/user_profile_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/user.dart';
import 'package:dmw/providers/user_provider.dart';
import 'package:dmw/utils/common_utils.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:dmw/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';

import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      read.clear();
    });
    Future.microtask(() {
      loadUserData();
      read.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<UserProvider>();
    const cardColor = Color(0xFF2A3441);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: AppTextStyles.whiteFont20Regular,
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              _buildDynamicAvatar(watch.gender),
              // const CircleAvatar(
              //   radius: 75,
              //   backgroundColor: AppColors.white,
              // ),
              const SizedBox(height: 40),
              Row(
                children: [
                  /// FIRST NAME DROPDOWN
                  firstName(),

                  const SizedBox(width: 16),
                  lastName()

                  /// LAST NAME
                ],
              ),
              const SizedBox(height: 16),
              email(),
              const SizedBox(height: 16),
              phoneNumber(),
              const SizedBox(height: 16),
              gender(),
              const SizedBox(height: 50),
              deleteAccount(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child:  watch.isLoading? CommonUtils.loader():ElevatedButton(
              style: AppButtonStyles.primaryButtonStyle,
              onPressed: () {
                // Save action
                _handleProfileSubmit();
              },
              child: const Text(
                "Save",
                style: AppTextStyles.whiteFont16Bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleProfileSubmit() async {
    if (_firstNameController.text.isEmpty) {
      CommonUtils.toastMessage("First Name mandatory(*) ");
      return;
    }
    if (_emailController.text.isNotEmpty &&
        !RegExp(r'^[a-zA-Z0-9._%±]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$')
            .hasMatch(_emailController.text)) {
      CommonUtils.toastMessage("Invalid email format");
      return;
    }
    User user = User(
        id: watch.user?.id,
        phone: watch.user!.phone,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: watch.gender,
        email: _emailController.text,
        state: 'verified_user');
    print(user.toJson());
    read.setIsLoading(true);
    UserProfileResponse userProfileResponse =
        await RestServiceImp.editProfile(user);
    if (userProfileResponse.isSuccess) {
      read.setIsLoading(false);
      LocalStorage.setFirstName(userProfileResponse.data.firstName!);
      LocalStorage.setLastName(userProfileResponse.data.lastName!);
      LocalStorage.setStatus(userProfileResponse.data.status!);      Navigator.pushNamedAndRemoveUntil(
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
      _firstNameController.text = userProfileResponse.data.firstName!;
      _lastNameController.text = userProfileResponse.data.lastName != null
          ? watch.user!.lastName!
          : '';
      _emailController.text =
          userProfileResponse.data.email != null ? watch.user!.email! : '';
      read.selectedGender( userProfileResponse.data.gender ?? "MALE");

      return;
    }
    CommonUtils.toastMessage(userProfileResponse.message);
  }

  Widget firstName() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF252D37), // Your Card Face Color
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.white12,
              blurRadius: 10,
              offset: Offset(2, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Matching Icon
            const Icon(Icons.person_outline, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Small Label Header
                  const Text(
                    "FIRST NAME",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  // Borderless TextField
                  TextField(
                    controller: _firstNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    cursorColor: Colors.white70,
                    onChanged: (v) {},
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                      border: InputBorder.none,
                      hintText: "ENTER NAME",
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget lastName() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF252D37), // Card Face Color
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.white12,
              blurRadius: 10,
              offset: Offset(2, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Person icon to match First Name
            const Icon(Icons.person_outline, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "LAST NAME",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextField(
                    controller: _lastNameController,
                    onChanged: (v) {},
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    cursorColor: Colors.white70,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                      border: InputBorder.none,
                      hintText: "ENTER NAME",
                      hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget email() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF252D37), // Card Face Color
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white12,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mail icon to match the context
          const Icon(Icons.mail_outline, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "EMAIL ADDRESS",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]')),
                  ],
                  onChanged: (value) {
                    // Your validation logic remains here
                    if (value.isEmpty) {
                      // Handle empty
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9._%±]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      // Handle invalid format
                    }
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  cursorColor: Colors.white70,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    border: InputBorder.none,
                    hintText: "EXAMPLE@MAIL.COM",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF252D37), // Card Face Color
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white12,
            blurRadius: 10,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Phone icon
          const Icon(Icons.phone_android_outlined,
              color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "MOBILE NUMBER",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  // Using your existing logic for the controller
                  controller: TextEditingController(text: watch.user?.phone),
                  enabled: false, // Disables user interaction
                  style: const TextStyle(
                    color: Colors.white60, // Dimmed text to show it's disabled
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                    border: InputBorder.none,
                    hintText: "NOT PROVIDED",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          // Optional: Add a lock icon to reinforce that it's disabled
          const Icon(Icons.lock_outline, color: Colors.white24, size: 16),
        ],
      ),
    );
  }

  Widget gender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            "GENDER",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),

        // Gender Selection Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF252D37), // Card Face Color
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.white12,
                blurRadius: 10,
                offset: Offset(2, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGenderOption("MALE", "Male"),
              _buildGenderOption("FEMALE", "Female"),
              _buildGenderOption("OTHER", "Other"),
            ],
          ),
        ),
      ],
    );
  }

// Helper method to keep the code clean
  Widget _buildGenderOption(String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: watch.gender,
          activeColor: Colors.white,
          // Selected circle color
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return Colors.white;
            return Colors.white38; // Unselected circle color
          }),
          onChanged: (val) {
            read.selectedGender(val!);
            // setState(() {
            //   _selectedGender = val;
            // });
          },
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicAvatar(String? gender) {
    IconData avatarIcon;
    Color iconColor;

    // Logic to switch icon based on selection
    switch (gender) {
      case "MALE":
        avatarIcon = Icons.face; // Or use a male image asset
        iconColor = Colors.blue.shade300;
        break;
      case "FEMALE":
        avatarIcon = Icons.face_3; // Or use a female image asset
        iconColor = Colors.pink.shade300;
        break;
      default:
        avatarIcon = Icons.account_circle;
        iconColor = Colors.white24;
    }

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 75,
            backgroundColor: const Color(0xFF252D37),
            // If you have local assets, use: backgroundImage: AssetImage(...)
            child: Icon(
              avatarIcon,
              size: 80,
              color: iconColor,
            ),
          ),
          // Camera edit button overlay
          // CircleAvatar(
          //   radius: 22,
          //   backgroundColor: const Color(0xFF007AFF),
          //   child: IconButton(
          //     icon: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
          //     onPressed: () {
          //       // Add your Image Picker logic here
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget deleteAccount(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showDeleteConfirmation(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        "Delete Account",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A313B), // Matches your dark theme
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Account Delete",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete your account? Your data will be permanently removed after 90 days of inactivity. Simply log in again before then to cancel this request.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Closes the popup
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.white38),
              ),
            ),
            // Delete Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context,
                    AppRoutes.loginScreen, (Route<dynamic> route) => false);
                // 3. Optional: Show a snackbar confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your data will be permanently removed after 90 days of inactivity.")),
                );
              },
              child: const Text("DELETE", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
