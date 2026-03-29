import 'package:dmw/utils/custom_button_styles.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_enums.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/widgets/dropdown_underlined_field.dart';
import 'package:dmw/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({ super.key });

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {

  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();

  String? _selectedBrandValue;
  String? _selectedModelValue;

  List<String> brandList = ["Honda", "Suzuki", "Hyundai", "Tata"];
  List<String> modelList = ["Altroz", "Punch", "Nexon", "Safari", "Harrier", "Tigor"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        centerTitle: true,
        title: const Text('Add Vehicle', style: AppTextStyles.whiteFont20Regular,),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Vehicle Details', style: AppTextStyles.primaryFont12Bold,),
                  const SizedBox(height: 36),
                  UnderlinedTextField(
                    colorTheme: ColorTheme.dark,
                    labelText: 'Vehicle Number',
                    controller: _vehicleNumberController,
                    onChanged: (value) {}
                  ),
                  const SizedBox(height: 40),
                  DropdownUnderlinedField<String>(
                    colorTheme: ColorTheme.dark,
                    labelText: 'Brand',
                    value: _selectedBrandValue,
                    items: brandList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBrandValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 40),
                  DropdownUnderlinedField<String>(
                    colorTheme: ColorTheme.dark,
                    labelText: 'Model',
                    value: _selectedModelValue,
                    items: modelList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedModelValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              color: AppColors.secondary,
              child: UnderlinedTextField(
                colorTheme: ColorTheme.dark,
                hintText: 'Enter Vehicle Name (optional)',
                helperText: 'Example: My Car, Friend\'s Car',
                controller: _vehicleNameController,
                onChanged: (value) {}
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              style: AppButtonStyles.primaryButtonStyle,
              child: const Text('Submit', style: AppTextStyles.whiteFont12Bold,)
            )
          ],
        ),
      ),
    );
  }
}