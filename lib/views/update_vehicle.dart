import 'package:dmw/ApiResponse/vehicle_response.dart';
import 'package:dmw/models/vehicle.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:dmw/views/all_saved_vehicles.dart';
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
    const cardColor = Color(0xFF2A3441);
    const textColor = Colors.white70;


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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white12,
                    blurRadius: 10,
                    offset: Offset(2, 0), // Pushes the shadow down to give depth
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Vehicle Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // Replace with your actual asset image
                  _vehicle.vehicleType==VehicleType.car.label?Image.asset('assets/images/car.png',height: 130,width: 150,):Image.asset('assets/images/bike.png',height: 130,width: 150,),
                  const SizedBox(height: 10),
                  const Text(
                    "SUBSCRIPTION: ACTIVE",
                    style: TextStyle(color: textColor, letterSpacing: 1.2, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            vehicleNumber(),
            brandWidget(),
            modelWidget(),
            colorWidget(),
            nickNameWidget(),
          ],
        ),
      ),

      // SingleChildScrollView(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     children: [
      //       UnderlinedTextField(
      //         colorTheme: ColorTheme.dark,
      //         labelText: "Vehicle Number",
      //         inputFormatters: [
      //           TextInputFormatter.withFunction((oldValue, newValue) {
      //             return newValue.copyWith(
      //                 text: newValue.text.toUpperCase());
      //           }),
      //         ],
      //         controller: vehicleNumberController,
      //         errorText: _vehicleNumberFieldErrorText,
      //         onChanged: (v) {
      //           String? newErrorText;
      //           if (v == null || v.isEmpty || v.length != 10) {
      //             newErrorText =
      //             'Minimum 10 characters(letters & spaces only)';
      //           } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(v)) {
      //             newErrorText =
      //             'Only letters and spaces are allowed';
      //           }
      //           setState(() {
      //             _vehicleNumberFieldErrorText = newErrorText!;
      //           });
      //         },
      //       ),
      //       const SizedBox(height: 30),
      //       // Row(
      //       //   children: [
      //       /// BRAND DROPDOWN
      //       // Expanded(
      //       //   child:
      //       DropdownUnderlinedField<Brand>(
      //         colorTheme: ColorTheme.dark,
      //         labelText: "Brand",
      //         value: /*brandWatch.selectedBrand ??*/ selectedBrand,
      //         items: brandWatch.brands
      //             .map((e) => DropdownMenuItem<Brand>(
      //           value: e,
      //           child: Text(e.name),
      //         ))
      //             .toList(),
      //         onChanged: (v) {
      //           // brandRead.setSelectedBrand(v!);
      //           // loadModels(selectedBrand!.id);
      //           setState(() {
      //             selectedBrand = v;
      //             loadModels(selectedBrand!.id);
      //           });
      //         },
      //       ),
      //       // ),
      //
      //       const SizedBox(height: 16),
      //
      //       /// MODEL DROPDOWN
      //       // Expanded(
      //       //   child:
      //       DropdownUnderlinedField<Model>(
      //         colorTheme: ColorTheme.dark,
      //         labelText: "Model",
      //         value: selectedModel,
      //         items: modelWatch.models
      //             .map((e) => DropdownMenuItem<Model>(
      //           value: e,
      //           child: Text(e.name,overflow: TextOverflow.ellipsis,maxLines: 1,
      //           ),
      //         ))
      //             .toList(),
      //         onChanged: (v) {
      //           // modelRead.setSelectedModel(v!);
      //           // loadColors(selectedModel!.id);
      //           setState(() {
      //             selectedModel = v;
      //             loadColors(selectedModel!.id);
      //           });
      //         },
      //       ),
      //       // ),
      //       //   ],
      //       // ),
      //       const SizedBox(height: 30),
      //       DropdownUnderlinedField<VehicleColor>(
      //         colorTheme: ColorTheme.dark,
      //         labelText: "Color",
      //         value: selectedColor,
      //         items: colorWatch.colors
      //             .map((e) => DropdownMenuItem(
      //           value: e,
      //           child: Text(e.name),
      //         ))
      //             .toList(),
      //         onChanged: (v) {
      //           // colorRead.setSelectedColor(v!);
      //           setState(() => selectedColor = v);
      //         },
      //       ),
      //       const SizedBox(height: 30),
      //
      //       UnderlinedTextField(
      //         colorTheme: ColorTheme.dark,
      //         hintText: "Vehicle Name (optional)",
      //         controller: vehicleNameController,
      //         onChanged: (v) {},
      //       ),
      //     ],
      //   ),
      // ),
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
    BrandResponse res = await RestServiceImp.getBrands(storage.getToken(),_vehicle.vehicleType==VehicleType.car.label?true:false);
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
          vehicleType: selectedModel?.vehicleType

          );

      print(vehicle.toJson());
      VehicleResponse res = await RestServiceImp.updateVehicle(vehicle);
      CommonUtils.toastMessage(res.message);
      Navigator.pop(context);
      // if(res.isSuccess){
      //   vehicleRead.updateVehicle(res.vehicle);
      //   Navigator.pop(context);
      //   // Navigator.pushReplacement(
      //   //   context,
      //   //   MaterialPageRoute(builder: (_) => const AllSavedVehicles()),
      //   // );
      //   return;
      // }



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

  // Future<void> loadColor() async {
  //   VehicleColorResponse response = await RestServiceImp.getColorByName(_vehicle.color!);
  //   if(response.isSuccess){
  //     colorRead.setSelectedColor(response.color);
  //   }
  // }

  Widget vehicleNumber(){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A313B), // Matches the dark card color
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 10,
            offset: Offset(0, 4), // Pushes the shadow down to give depth
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The filter icon from the UI
          const Icon(Icons.badge_outlined, color: Colors.white70, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Label at the top
                const Text(
                  "VEHICLE NO:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  controller: vehicleNumberController,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  cursorColor: Colors.white,
                  // Keeping your logic intact
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue.copyWith(text: newValue.text.toUpperCase());
                    }),
                  ],
                  onChanged: (v) {
                    String? newErrorText;
                    if (v.isEmpty || v.length != 10) {
                      newErrorText = 'Minimum 10 characters(letters & spaces only)';
                    } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(v)) {
                      newErrorText = 'Only letters and spaces are allowed';
                    }
                    // setState(() {
                    //   // _vehicleNumberFieldErrorText = newErrorText;
                    // });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    // contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    contentPadding: const EdgeInsets.only(top: 8,bottom: 0),
                    border: InputBorder.none, // Removes the underline
                    hintText: "ENTER VEHICLE NUMBER",
                    hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                    // Display error text below the field if it exists
                    errorText: _vehicleNumberFieldErrorText,
                    errorStyle: const TextStyle(fontSize: 10, height: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget brandWidget(){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A313B), // Dark card color from UI
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 10,
            offset: Offset(0, 4), // Pushes the shadow down to give depth
          ),
        ],
      ),

      child: Row(
        children: [
          // Icon on the left
          const Icon(Icons.filter_alt_outlined, color: Colors.white70, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Small uppercase label
                const Text(
                  "BRAND:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                DropdownButtonFormField<Brand>(
                  value: selectedBrand,
                  borderRadius: BorderRadius.circular(15), // Rounded corners for the popup
                  dropdownColor: const Color(0xFF2A313B), // Matches container when opened
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 0, bottom: 10),
                    border: InputBorder.none, // Removes the default underline
                    hint: Text(
                      "SELECT BRAND",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    // hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  items: brandWatch.brands
                      .map((e) => DropdownMenuItem<Brand>(
                    value: e,
                    child: Text(e.name),
                  ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedBrand = v;
                      loadModels(selectedBrand!.id);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget modelWidget(){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A313B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 10,
            offset: Offset(0, 4), // Pushes the shadow down to give depth
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_outlined, color: Colors.white70, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "MODEL:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                DropdownButtonFormField<Model>(
                  value: modelWatch.models.contains(selectedModel) ? selectedModel : null,
                  // Fixes the black hint issue:
                  hint: const Text(
                    "SELECT MODEL",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  dropdownColor: const Color(0xFF2A313B),
                  borderRadius: BorderRadius.circular(15), // Rounded corners for the popup
                  isDense: true, // Crucial for matching height
                  isExpanded: true, // Prevents layout jumping
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 9, bottom: 9),
                    border: InputBorder.none,
                  ),
                  items: modelWatch.models
                      .map((e) => DropdownMenuItem<Model>(
                    value: e,
                    child: Text(
                      e.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedModel = v;
                      loadColors(selectedModel!.id);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget colorWidget(){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A313B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 10,
            offset: Offset(0, 4), // Pushes the shadow down to give depth
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon changed to Palette for the Color field
          const Icon(Icons.palette_outlined, color: Colors.white70, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "COLOR:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                DropdownButtonFormField<VehicleColor>(
                  value: colorWatch.colors
                      .where((c) => c.id == selectedColor?.id)
                      .length == 1
                      ? colorWatch.colors.firstWhere((c) => c.id == selectedColor?.id)
                      : null,
                  borderRadius: BorderRadius.circular(15), // Rounded corners for the popup
                  // Fixed: Hint text is now white/grey instead of black
                  hint: const Text(
                    "ADD COLOR / ENTER",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  dropdownColor: const Color(0xFF2A313B),
                  isDense: true,
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 9, bottom: 9),
                    border: InputBorder.none,
                  ),
                  items: colorWatch.colors
                      .map((e) => DropdownMenuItem<VehicleColor>(
                    value: e,
                    child: Text(e.name),
                  ))
                      .toList(),
                  onChanged: (v) {
                    setState(() => selectedColor = v);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nickNameWidget(){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A313B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.white10,
            blurRadius: 10,
            offset: Offset(0, 4), // Pushes the shadow down to give depth
          ),
        ],
      ),
      child: Row(
        children: [
          // Car icon for the specific vehicle name
          const Icon(Icons.directions_car_filled_outlined, color: Colors.white70, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "VEHICLE NAME:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  controller: vehicleNameController,
                  onChanged: (v) {},
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                  cursorColor: Colors.white70,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 8,bottom: 0),
                    border: InputBorder.none,
                    // Fixed: Hint text is now white/grey instead of black
                    hintText: "VEHICLE NAME (OPTIONAL)",
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}