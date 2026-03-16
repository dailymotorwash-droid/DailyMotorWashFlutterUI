import 'package:car_wash/ApiResponse/vehicle_response.dart';
import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/views/all_saved_vehicles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../ApiResponse/brand_response.dart';
import '../ApiResponse/vehicle_color_response.dart';
import '../ApiResponse/vehicle_model_response.dart';
import '../Apis/RestServiceImp.dart';
import '../models/brand.dart';
import '../models/model.dart';
import '../models/vehicle_color.dart';
import '../providers/brand_provider.dart';
import '../providers/vehicle_color_provider.dart';
import '../providers/vehicle_model_provider.dart';
import '../providers/vehicle_provider.dart';
import '../utils/common_utils.dart';
import '../utils/custom_button_styles.dart';
import '../utils/custom_colors.dart';
import '../utils/custom_enums.dart';
import '../utils/custom_text_styles.dart';
import '../utils/local_storage.dart';
import '../widgets/dropdown_underlined_field.dart';
import '../widgets/underlined_text_field.dart';

class UpdateVehicle extends StatefulWidget{
  final Vehicle vehicle;

  const UpdateVehicle({super.key, required this.vehicle});


  @override
  State<UpdateVehicle> createState() =>
      _UpdateVehicle();
}


class _UpdateVehicle extends State<UpdateVehicle>{

  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();

  late BrandProvider brandRead, brandWatch;
  late VehicleModelProvider modelRead, modelWatch;
  late VehicleColorProvider colorRead, colorWatch;
  late VehicleProvider vehicleRead;


  String _vehicleNumberFieldErrorText = '';
  Brand? selectedBrand;
  Model? selectedModel;
  VehicleColor? selectedColor;

  late Vehicle _vehicle;

  @override
  void initState() {
    // TODO: implement initState
    brandRead = context.read<BrandProvider>();
    modelRead = context.read<VehicleModelProvider>();
    colorRead = context.read<VehicleColorProvider>();
    vehicleRead = context.read<VehicleProvider>();

    _vehicle = widget.vehicle;
    vehicleNumberController.text = _vehicle.registrationNumber!;
    vehicleNameController.text = _vehicle.nickName!;

    Future.microtask(() {
      loadBrands();
      // loadModel();
      // loadBrand();
      // loadColor();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    brandWatch = context.watch<BrandProvider>();
    modelWatch = context.watch<VehicleModelProvider>();
    colorWatch = context.watch<VehicleColorProvider>();
    // v = context.watch<BrandProvider>();
    brandWatch = context.watch<BrandProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text(
          "Edit Vehicle",
          style: AppTextStyles.whiteFont20Regular,
        ),
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            UnderlinedTextField(
              colorTheme: ColorTheme.dark,
              labelText: "Vehicle Number",
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(
                      text: newValue.text.toUpperCase());
                }),
              ],
              controller: vehicleNumberController,
              errorText: _vehicleNumberFieldErrorText,
              onChanged: (v) {
                String? newErrorText;
                if (v == null || v.isEmpty || v.length != 10) {
                  newErrorText =
                  'Minimum 10 characters(letters & spaces only)';
                } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(v)) {
                  newErrorText =
                  'Only letters and spaces are allowed';
                }
                setState(() {
                  _vehicleNumberFieldErrorText = newErrorText!;
                });
              },
            ),
            const SizedBox(height: 30),
            // Row(
            //   children: [
            /// BRAND DROPDOWN
            // Expanded(
            //   child:
            DropdownUnderlinedField<Brand>(
              colorTheme: ColorTheme.dark,
              labelText: "Brand",
              value: /*brandWatch.selectedBrand ??*/ selectedBrand,
              items: brandWatch.brands
                  .map((e) => DropdownMenuItem<Brand>(
                value: e,
                child: Text(e.name),
              ))
                  .toList(),
              onChanged: (v) {
                // brandRead.setSelectedBrand(v!);
                // loadModels(selectedBrand!.id);
                setState(() {
                  selectedBrand = v;
                  loadModels(selectedBrand!.id);
                });
              },
            ),
            // ),

            const SizedBox(height: 16),

            /// MODEL DROPDOWN
            // Expanded(
            //   child:
            DropdownUnderlinedField<Model>(
              colorTheme: ColorTheme.dark,
              labelText: "Model",
              value: selectedModel,
              items: modelWatch.models
                  .map((e) => DropdownMenuItem<Model>(
                value: e,
                child: Text(e.name,overflow: TextOverflow.ellipsis,maxLines: 1,
                ),
              ))
                  .toList(),
              onChanged: (v) {
                // modelRead.setSelectedModel(v!);
                // loadColors(selectedModel!.id);
                setState(() {
                  selectedModel = v;
                  loadColors(selectedModel!.id);
                });
              },
            ),
            // ),
            //   ],
            // ),
            const SizedBox(height: 30),
            DropdownUnderlinedField<VehicleColor>(
              colorTheme: ColorTheme.dark,
              labelText: "Color",
              value: selectedColor,
              items: colorWatch.colors
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.name),
              ))
                  .toList(),
              onChanged: (v) {
                // colorRead.setSelectedColor(v!);
                setState(() => selectedColor = v);
              },
            ),
            const SizedBox(height: 30),

            UnderlinedTextField(
              colorTheme: ColorTheme.dark,
              hintText: "Vehicle Name (optional)",
              controller: vehicleNameController,
              onChanged: (v) {},
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
                  updateVehicle();
                },
                child: const Text("Save",style: AppTextStyles.whiteFont16Bold,),
              ),
            ),
          ),
        )
    );
  }

  Future<void> loadBrands() async {
    var storage = await LocalStorage.getInstance();
    BrandResponse res = await RestServiceImp.getBrands(storage.getToken());
    if (res.isSuccess) {
      brandRead.setBrands(res.data);
    }
  }

  Future<void> loadModels(int id) async {
    var storage = await LocalStorage.getInstance();
    VehicleModelResponse res = await RestServiceImp.getModels(
        storage.getToken(), id, _vehicle.vehicleType!);
    if (res.isSuccess) {
      modelRead.setModels(res.data);
    }
  }

  Future<void> loadColors(int id) async {
    var storage = await LocalStorage.getInstance();
    VehicleColorResponse res =
    await RestServiceImp.getColors(storage.getToken(), id);
    if (res.isSuccess) {
      colorRead.setColors(res.data);
    }
  }

  Future<void> updateVehicle() async {

    if (vehicleNumberController.text.isEmpty ||
        selectedBrand == null ||
        selectedModel == null ||
        selectedColor == null) {
      CommonUtils.toastMessage('Please Fill All Vehicle Details');
    } else if (vehicleNumberController.text.length < 10) {
      CommonUtils.toastMessage('Registration Number Should be 10 Char');
    }else{
      Vehicle vehicle = Vehicle(
          id: _vehicle.id,
          model: selectedModel?.name,
          color: selectedColor?.name,
          brand: selectedBrand?.name,
          category: selectedModel?.vehicleSize,
          size: selectedModel?.vehicleSize,
          registrationNumber: vehicleNumberController.text.toString(),
          nickName: vehicleNameController.text.toString(),
          );

      print(vehicle.toJson());
      VehicleResponse res = await RestServiceImp.updateVehicle(vehicle);
      if(res.isSuccess){
        vehicleRead.updateVehicle(res.vehicle);
        Navigator.pop(context);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const AllSavedVehicles()),
        // );
        return;
      }

      CommonUtils.toastMessage(res.message);


    }
  }

  Future<void> loadModel() async{
    VehicleModelResponse response = await RestServiceImp.getModelByName(_vehicle.model!);
    if(response.isSuccess){
     modelRead.setSelectedModel(response.model);
    }
  }

  Future<void> loadBrand() async {
    BrandResponse response = await RestServiceImp.getBrandByName(_vehicle.brand!);
    if(response.isSuccess){
      brandRead.setSelectedBrand(response.brand);
    }
  }

  Future<void> loadColor() async {
    VehicleColorResponse response = await RestServiceImp.getColorByName(_vehicle.color!);
    if(response.isSuccess){
      colorRead.setSelectedColor(response.color);
    }
  }
}