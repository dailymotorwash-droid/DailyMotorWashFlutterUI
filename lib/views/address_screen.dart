import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  final Logger logger = Logger();

  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressTypeContoller = TextEditingController();

  int _selectedAddressTypeIndex = -1;
  final List<String> addressTypeOptions = ["HOME", "WORK", "OTHER"];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address', style: AppTextStyles.blackFont20Regular),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: const BoxDecoration(
                color: AppColors.tertiary,
              ),
              child: Row(
                children: [
                  const Icon(Icons.pin_drop),
                  const SizedBox(width: 12),
                  const Text('Indirapuram', style: AppTextStyles.blackFont16Regular,),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      logger.i('Change Address');
                    }, 
                    style: AppButtonStyles.primaryOutlinedButtonStyle,
                    child: const Text('change', style: AppTextStyles.secondaryFont12Bold,),
                  )
                
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  UnderlinedTextField(
                    
                    labelText: '*Flat No / H.No',
                    hintText: 'Example: 17B, A-23',
                    controller: _flatNumberController,
                    onChanged: (value) => null,
                  ),
                  const SizedBox(height: 24),
                  UnderlinedTextField(
                  
                    labelText: 'Addres Line 2',
                    hintText: 'Example: XYZ City, ABC Village',
                    controller: _addressLine2Controller,
                    onChanged: (value) => null,
                  ),
                  const SizedBox(height: 24),
                  UnderlinedTextField(
                    
                    labelText: 'Landmark',
                    hintText: 'Example: near ABC School',
                    controller: _landmarkController,
                    onChanged: (value) => null,
                  ),
                  const SizedBox(height: 24),
                  UnderlinedTextField(
                    
                    labelText: 'Pincode',
                    hintText: 'Example: 201XXX, 110XXX',
                    controller: _pincodeController,
                    onChanged: _handleEmptyFieldValidation,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: 
                      List.generate(3, (index) {
                        bool isSelected = _selectedAddressTypeIndex == index;
                        return ChoiceChip(
                          label: Text(
                            addressTypeOptions[index], 
                            style: isSelected ? AppTextStyles.whiteFont12Bold : AppTextStyles.blackFont12Regular,
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.secondary,
                          side: BorderSide(
                            color: AppColors.tertiary,
                            width: isSelected ? 0 : 2,
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedAddressTypeIndex = index;
                            });
                          },
                        );
                      }), 
                  ),
                  const SizedBox(height: 12),
                  _selectedAddressTypeIndex == 2 
                  ? UnderlinedTextField(
                    
                    hintText: 'Example: Temp',
                    controller: _addressTypeContoller,
                    onChanged: _selectedAddressTypeIndex == 2 ? _handleEmptyFieldValidation : (value) => null,
                  )
                  : Container(),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _handleAddressFormSubmit,
                    style: AppButtonStyles.primaryButtonStyle,
                    child: const Text('Submit', style: AppTextStyles.whiteFont16Bold,)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static String? _handleEmptyFieldValidation(value) {
    if(value != null && value.isEmpty) {
      return "Above field cannot be empty";
    }

    return null;
  }

  void _handleAddressFormSubmit() {
  
      Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.homeScreen, (Route<dynamic> route) => false);
  }
}

