import 'package:car_wash/ApiResponse/add_vehicle_and_address_response.dart';
import 'package:car_wash/ApiResponse/address_response.dart';
import 'package:car_wash/ApiResponse/brand_response.dart';
import 'package:car_wash/ApiResponse/search_address_response.dart';
import 'package:car_wash/ApiResponse/vehicle_color_response.dart';
import 'package:car_wash/ApiResponse/vehicle_model_response.dart';
import 'package:car_wash/ApiResponse/vehicle_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/address.dart';
import 'package:car_wash/models/brand.dart';
import 'package:car_wash/models/master_address.dart';
import 'package:car_wash/models/model.dart';
import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/models/vehicle_and_address.dart';
import 'package:car_wash/models/vehicle_color.dart';
import 'package:car_wash/providers/address_provider.dart';
import 'package:car_wash/providers/brand_provider.dart';
import 'package:car_wash/providers/search_address_provider.dart';
import 'package:car_wash/providers/vehicle_color_provider.dart';
import 'package:car_wash/providers/vehicle_model_provider.dart';
import 'package:car_wash/providers/vehicle_provider.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_enums.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/local_storage.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/dropdown_underlined_field.dart';
import 'package:car_wash/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddVehicleAndAddressScreen extends StatefulWidget {
  final VehicleType vehicleType;

  const AddVehicleAndAddressScreen({super.key, required this.vehicleType});

  @override
  State<AddVehicleAndAddressScreen> createState() =>
      _AddVehicleAndAddressScreenState();
}

class _AddVehicleAndAddressScreenState
    extends State<AddVehicleAndAddressScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  late VehicleType vehicleType;

  // bool showDropdown = false;

  late BrandProvider brandRead, brandWatch;
  late VehicleModelProvider modelRead, modelWatch;
  late VehicleColorProvider colorRead, colorWatch;
  late SearchAddressProvider searchAddressRead, searchAddressWatch;
  late AddressProvider addressRead, addressWatch;
  late VehicleProvider vehicleRead;

  /// VEHICLE CONTROLLERS
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController controller = TextEditingController();

  Brand? selectedBrand;
  Model? selectedModel;
  VehicleColor? selectedColor;

  /// ADDRESS CONTROLLERS
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // final TextEditingController addressLine2Controller = TextEditingController();
  // final TextEditingController landmarkController = TextEditingController();
  // final TextEditingController pincodeController = TextEditingController();

  Vehicle? vehicle;

  int selectedAddressType = -1;

  int selectedAddressIndex = 0; // default first saved address
  bool showNewAddressForm = false;
  List<String> suggestions = [];
  String? profileStatus;
  String _vehicleNumberFieldErrorText = '';

  @override
  void initState() {
    // TODO: implement initState
    brandRead = context.read<BrandProvider>();
    modelRead = context.read<VehicleModelProvider>();
    colorRead = context.read<VehicleColorProvider>();
    searchAddressRead = context.read<SearchAddressProvider>();
    addressRead = context.read<AddressProvider>();
    vehicleRead = context.read<VehicleProvider>();
    vehicleType = widget.vehicleType;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchAddressRead.clearSelectedAddress();

    });
    Future.microtask(() {
      addressRead.setIsLoading(true);
      loadAddresses();
      loadBrands();
    });

    super.initState();
  }

  void nextStep() {
    if (vehicleNumberController.text.isEmpty ||
        selectedBrand == null ||
        selectedModel == null ||
        selectedColor == null) {
      CommonUtils.toastMessage('Please Fill All Vehicle Details');
    } else if (vehicleNumberController.text.length < 9) {
      CommonUtils.toastMessage('Registration Number Should be 10 Char');
    } else {
      if (currentStep == 0) {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        setState(() {
          currentStep = 1;
        });
      } else {
        submitForm();
      }
    }
  }

  void backStep() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.ease);

    setState(() {
      currentStep = 0;
    });
  }

  Future<void> submitForm() async {
    String? firstName, lastName;
    if (selectedAddressIndex != -1) {
      vehicle = getVehicle(addressWatch.addresses[selectedAddressIndex].id);
      VehicleResponse res = await RestServiceImp.addVehicle(vehicle!);
      if (res.isSuccess) {
        vehicleRead.addVehicle(res.vehicle);
        Navigator.pop(context);
      }
      CommonUtils.toastMessage(res.message);
      return;
    }
    bool isFistNameUpdated = false;
    if (profileStatus == ProfileStatus.pending.label) {
      if (_firstNameController.text.isEmpty) {
        CommonUtils.toastMessage("First Name mandatory(*) ");
        return;
      }
      firstName = _firstNameController.text.toString();
      lastName = _lastNameController.text.toString();
      isFistNameUpdated = true;
    }
    if (_flatNumberController.text.isNotEmpty) {
      if (searchAddressWatch.selectedAddress != null) {
        MasterAddress? address = searchAddressWatch.selectedAddress;
        Address add = Address(
            firstName: firstName,
            lastName: lastName,
            houseNo: _flatNumberController.text,
            addressLine1: '${address?.societyName}' ,
            addressLine2: address?.societyLine1,
            addressLine3: address?.societyLine2,
            addressLine4: address?.societyLine3,
            pinCode: address?.pinCode,
            district: address?.district,
            city: address?.city,
            masterAddressId: searchAddressWatch.selectedAddress?.id,
            state: address?.state);

        VehicleAndAddress vehicleAndAddress =
            VehicleAndAddress(address: add, vehicle: getVehicle(null));
        print(vehicleAndAddress.toJson());
        // AddVehicleAndAddressResponse res =
        //     await RestServiceImp.addVehicleAndAddress(vehicleAndAddress);
        // if (res.isSuccess) {
        //   LocalStorage.setStatus(ProfileStatus.completed.label);
        //   if(isFistNameUpdated) {
        //     LocalStorage.setFirstName(firstName!);
        //     LocalStorage.setLastName(lastName!);
        //   }
        //   vehicleRead.addVehicle(res.data.vehicle!);
        //   Navigator.pop(context);
        // }
        // CommonUtils.toastMessage(res.message);
      } else {
        CommonUtils.toastMessage("Please Select Society");
      }
    } else {
      CommonUtils.toastMessage("Please Fill Flat No./H.No.");
    }
  }

  Vehicle getVehicle(String? addressId) {
    return Vehicle(
        vehicleType: vehicleType.label,
        model: selectedModel?.name,
        color: selectedColor?.name,
        brand: selectedBrand?.name,
        category: selectedModel?.vehicleSize,
        size: selectedModel?.vehicleSize,
        registrationNumber: vehicleNumberController.text.toString(),
        nickName: vehicleNameController.text.toString(),
        addressId: addressId);
  }

  @override
  Widget build(BuildContext context) {
    brandWatch = context.watch<BrandProvider>();
    modelWatch = context.watch<VehicleModelProvider>();
    colorWatch = context.watch<VehicleColorProvider>();
    searchAddressWatch = context.watch<SearchAddressProvider>();
    addressWatch = context.watch<AddressProvider>();
      if (addressWatch.addresses.isEmpty) {
        selectedAddressIndex = -1;
      }
    const backgroundColor = Color(0xFF1E2630);
    const cardColor = Color(0xFF2A3441);
    const accentColor = Color(0xFFE55D5D);
    const textColor = Colors.white70;
    double itemHeight = 50;
    double maxHeight = 200;
    double dropdownHeight =
        (searchAddressWatch.suggestions.length * itemHeight) > maxHeight
            ? maxHeight
            : searchAddressWatch.suggestions.length * itemHeight;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: Text(
          currentStep == 0 ? "Step 1: Vehicle" : "Step 2: Address",
          style: AppTextStyles.whiteFont20Regular,
        ),
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          /// STEP INDICATOR
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Step ${currentStep + 1} of 2",
              style: AppTextStyles.whiteFont12Bold,
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [

                // SingleChildScrollView(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Column(
                //     children: [
                //       // Vehicle Profile Card
                //       Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.all(16),
                //         decoration: BoxDecoration(
                //           color: cardColor,
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Column(
                //           children: [
                //             const Text(
                //               "Vehicle Profile",
                //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                //             ),
                //             const SizedBox(height: 10),
                //             // Replace with your actual asset image
                //             const Icon(Icons.directions_car, size: 120, color: Colors.purpleAccent),
                //             const SizedBox(height: 10),
                //             const Text(
                //               "SUBSCRIPTION: INACTIVE",
                //               style: TextStyle(color: textColor, letterSpacing: 1.2, fontSize: 12),
                //             ),
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //
                //       // Input Fields
                //       _buildInputField(Icons.filter_alt_outlined, "VEHICLE NO:", "ENTER VEHICLE NUMBER", cardColor),
                //       _buildInputField(Icons.filter_alt_outlined, "BRAND:", "SELECT BRAND", cardColor, isDropdown: true),
                //       _buildInputField(Icons.filter_alt_outlined, "MODEL:", "SELECT MODEL", cardColor, isDropdown: true),
                //       _buildInputField(Icons.palette_outlined, "COLOR:", "ADD COLOR / ENTER", cardColor),
                //
                //     ],
                //   ),
                // ),

                /// STEP 1 VEHICLE
                SingleChildScrollView(
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
                            vehicleType==VehicleType.car?Image.asset('assets/images/car.png',height: 130,width: 150,):Image.asset('assets/images/bike.png',height: 130,width: 150,),
                            const SizedBox(height: 10),
                            const Text(
                              "SUBSCRIPTION: INACTIVE",
                              style: TextStyle(color: textColor, letterSpacing: 1.2, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // UnderlinedTextField(
                      //   colorTheme: ColorTheme.dark,
                      //   labelText: "Vehicle Number",
                      //   inputFormatters: [
                      //     TextInputFormatter.withFunction((oldValue, newValue) {
                      //       return newValue.copyWith(
                      //           text: newValue.text.toUpperCase());
                      //     }),
                      //   ],
                      //   controller: vehicleNumberController,
                      //   errorText: _vehicleNumberFieldErrorText,
                      //   onChanged: (v) {
                      //     String? newErrorText;
                      //     if (v == null || v.isEmpty || v.length != 10) {
                      //       newErrorText =
                      //           'Minimum 10 characters(letters & spaces only)';
                      //     } else if (!RegExp(r'^[a-zA-Z\s]*$').hasMatch(v)) {
                      //       newErrorText =
                      //           'Only letters and spaces are allowed';
                      //     }
                      //     setState(() {
                      //       _vehicleNumberFieldErrorText = newErrorText!;
                      //     });
                      //   },
                      // ),
                      vehicleNumber(),
                      // const SizedBox(height: 30),
                      // Row(
                      //   children: [
                          /// BRAND DROPDOWN
                          // Expanded(
                          //   child:
                          //   DropdownUnderlinedField<Brand>(
                          //     colorTheme: ColorTheme.dark,
                          //     labelText: "Brand",
                          //     value: selectedBrand,
                          //     items: brandWatch.brands
                          //         .map((e) => DropdownMenuItem<Brand>(
                          //               value: e,
                          //               child: Text(e.name),
                          //             ))
                          //         .toList(),
                          //     onChanged: (v) {
                          //       setState(() {
                          //         selectedBrand = v;
                          //         loadModels(selectedBrand!.id);
                          //       });
                          //     },
                          //   ),
                          // ),

                      brandWidget(),

                          // const SizedBox(height: 16),

                          /// MODEL DROPDOWN
                          // Expanded(
                          //   child:
                          //   DropdownUnderlinedField<Model>(
                          //     colorTheme: ColorTheme.dark,
                          //     labelText: "Model",
                          //     value: selectedModel,
                          //     items: modelWatch.models
                          //         .map((e) => DropdownMenuItem<Model>(
                          //               value: e,
                          //               child: Text(e.name,overflow: TextOverflow.ellipsis,maxLines: 1,
                          //               ),
                          //             ))
                          //         .toList(),
                          //     onChanged: (v) {
                          //       setState(() {
                          //         selectedModel = v;
                          //         loadColor(selectedModel!.id);
                          //       });
                          //     },
                          //   ),
                          // ),
                      //   ],
                      // ),

                      modelWidget(),
                      // const SizedBox(height: 30),
                      // DropdownUnderlinedField<VehicleColor>(
                      //   colorTheme: ColorTheme.dark,
                      //   labelText: "Color",
                      //   value: selectedColor,
                      //   items: colorWatch.colors
                      //       .map((e) => DropdownMenuItem(
                      //             value: e,
                      //             child: Text(e.name),
                      //           ))
                      //       .toList(),
                      //   onChanged: (v) {
                      //     setState(() => selectedColor = v);
                      //   },
                      // ),
                      colorWidget(),
                      // const SizedBox(height: 30),

                      // UnderlinedTextField(
                      //   colorTheme: ColorTheme.dark,
                      //   hintText: "Vehicle Name (optional)",
                      //   controller: vehicleNameController,
                      //   onChanged: (v) {},
                      // ),
                      nickNameWidget(),
                    ],
                  ),
                ),

                /// STEP 2 ADDRESS
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addressWatch.addresses.isEmpty ? '' : "Saved Address",
                        style: AppTextStyles.whiteFont12Bold,
                      ),

                      const SizedBox(height: 10),

                      /// SAVED ADDRESSES
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: addressWatch.isLoading
                            ? CommonUtils.loader()
                            : addressWatch.addresses.isEmpty
                                ? Container()
                                : Row(
                                    children: List.generate(
                                        addressWatch.addresses.length, (index) {
                                      final item =
                                          addressWatch.addresses[index];

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedAddressIndex = index;
                                            showNewAddressForm = false;
                                          });
                                        },
                                        child: Container(
                                          width: 220,
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2A2B3D),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color:
                                                  selectedAddressIndex == index
                                                      ? Colors.purple
                                                      : Colors.transparent,
                                              width: 2,
                                            ),

                                          ),
                                          child: Row(
                                            children: [
                                              // Icon(
                                              //   selectedAddressIndex == index
                                              //       ? Icons.radio_button_checked
                                              //       : Icons.radio_button_off,
                                              //   color: Colors.purple,
                                              // ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.addressLine2!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      item.addressLine1!,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                      ),

                      /// ADD NEW ADDRESS OPTION
                      addressWatch.addresses.isEmpty?Container():RadioListTile<int>(
                        value: -1,
                        groupValue: selectedAddressIndex,
                        title: const Text(
                          "Add New Address",
                          style: AppTextStyles.whiteFont12Bold,
                        ),
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            selectedAddressIndex = -1;
                            showNewAddressForm = true;
                          });
                        },
                      ),

                      /// ADDRESS FORM
                      if (showNewAddressForm||addressWatch.addresses.isEmpty)
                        Column(
                          children: [
                            if (profileStatus == ProfileStatus.pending.label)
                              Row(
                                children: [
                                  /// FIRST NAME DROPDOWN
                                  firstName(),


                                  const SizedBox(width: 16),

                                  /// LAST NAME DROPDOWN
                                  lastName(),

                                ],
                              ),
                            const SizedBox(height: 30),


                            // UnderlinedTextField(
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: "*Flat No / H.No",
                            //   controller: _flatNumberController,
                            //   inputFormatters: [
                            //     TextInputFormatter.withFunction(
                            //         (oldValue, newValue) {
                            //       return newValue.copyWith(
                            //           text: newValue.text.toUpperCase());
                            //     }),
                            //   ],
                            //   onChanged: (v) {},
                            // ),
                            flatWidget(),
                            const SizedBox(height: 20),
                            searchSociety(),
                            // Column(
                            //   children: [
                            //     TextField(
                            //       controller: controller,
                            //       style: AppTextStyles.whiteFont12Bold,
                            //       decoration: const InputDecoration(
                            //         hintText: "Search Society",
                            //         border: OutlineInputBorder(),
                            //       ),
                            //       onChanged: (value) {
                            //         if (value.isEmpty) {
                            //           // setState(() {
                            //           //   showDropdown = false;
                            //           searchAddressRead.isDropDownEnable(false);
                            //           searchAddressRead.clearSelectedAddress();
                            //           // });
                            //         } else {
                            //           if (value.length > 3) {
                            //             searchAddress(value);
                            //           }
                            //         }
                            //       },
                            //     ),
                            //     if (searchAddressWatch.showDropdown)
                            //       Container(
                            //         margin: const EdgeInsets.only(top: 4),
                            //         decoration: BoxDecoration(
                            //           color: const Color(0xFF2B2D42),
                            //           // dark background
                            //           borderRadius: BorderRadius.circular(8),
                            //           border: Border.all(
                            //             color: Colors.grey.shade400,
                            //             width: 1,
                            //           ),
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: Colors.black.withOpacity(0.3),
                            //               blurRadius: 6,
                            //               offset: const Offset(0, 3),
                            //             ),
                            //           ],
                            //         ),
                            //         child: SizedBox(
                            //           height: dropdownHeight,
                            //           child: Container(
                            //             height: 200,
                            //             decoration: BoxDecoration(
                            //               border:
                            //                   Border.all(color: Colors.grey),
                            //             ),
                            //             child: ListView.builder(
                            //               shrinkWrap: true,
                            //               itemCount: searchAddressWatch
                            //                   .suggestions.length,
                            //               itemBuilder: (context, index) {
                            //                 return ListTile(
                            //                   title: Text(
                            //                     searchAddressWatch
                            //                         .suggestions[index]
                            //                         .societyName,
                            //                     style: AppTextStyles
                            //                         .whiteFont12Bold,
                            //                   ),
                            //                   onTap: () {
                            //                     controller.text =
                            //                         searchAddressWatch
                            //                             .suggestions[index]
                            //                             .societyName;
                            //                     searchAddressRead
                            //                         .isDropDownEnable(false);
                            //                     searchAddressRead
                            //                         .setSelectedAddress(
                            //                             searchAddressWatch
                            //                                     .suggestions[
                            //                                 index]);
                            //                     // setState(() {
                            //                     //   showDropdown = false;
                            //                     // });
                            //                   },
                            //                 );
                            //               },
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //   ],
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              searchAddressRead.selectedAddress != null
                                  ? '${searchAddressRead.selectedAddress?.societyLine1},${searchAddressRead.selectedAddress?.societyLine2}'
                                      '${searchAddressRead.selectedAddress!.societyLine3.isEmpty ? '' : ',${searchAddressRead.selectedAddress!.societyLine3}'}${searchAddressRead.selectedAddress!.city.isEmpty ? '' : ',${searchAddressRead.selectedAddress!.city}'}'
                                      ',${searchAddressRead.selectedAddress?.district},${searchAddressRead.selectedAddress?.state}- ${searchAddressRead.selectedAddress?.pinCode}'
                                  : '',
                              style: AppTextStyles.whiteFont12Bold,
                            ),
                            // UnderlinedTextField(
                            //   isFieldEnabled:false,
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: '${searchAddressRead.selectedAddress!=null?searchAddressRead.selectedAddress?.societyLine1:''}',
                            //   // controller: _addressLine2Controller,
                            //   onChanged: (v) {},
                            // ),
                            // const SizedBox(height: 20),
                            // UnderlinedTextField(
                            //   isFieldEnabled:false,
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: '${searchAddressRead.selectedAddress!=null?searchAddressRead.selectedAddress?.societyLine2:''}',
                            //   // controller: _landmarkController,
                            //   onChanged: (v) {},
                            // ),
                            const SizedBox(height: 20),
                            // UnderlinedTextField(
                            //   isFieldEnabled:false,
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: '${searchAddressRead.selectedAddress!=null?searchAddressRead.selectedAddress?.societyLine3:''}',
                            //   onChanged: (v) {},
                            // ),
                            // const SizedBox(height: 20),
                            // UnderlinedTextField(
                            //   isFieldEnabled:false,
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: '${searchAddressRead.selectedAddress!=null?searchAddressRead.selectedAddress?.city:''}',
                            //   onChanged: (v) {},
                            // ),
                            // const SizedBox(height: 20),
                            // UnderlinedTextField(
                            //   isFieldEnabled:false,
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: '${searchAddressRead.selectedAddress!=null?searchAddressRead.selectedAddress?.state:''}',
                            //   onChanged: (v) {},
                            // ),
                            // const SizedBox(height: 20),
                            // UnderlinedTextField(
                            //   isFieldEnabled:false,
                            //   colorTheme: ColorTheme.dark,
                            //   labelText: '${searchAddressRead.selectedAddress!=null?searchAddressRead.selectedAddress?.pinCode:''}',
                            //   // controller: _pincodeController,
                            //   onChanged: (v) {},
                            // ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),

          /// BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (currentStep == 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: backStep,
                      child: const Text("Back"),
                    ),
                  ),
                if (currentStep == 1) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: AppButtonStyles.primaryButtonStyle,
                    child: Text(
                      currentStep == 0 ? "Next" : "Submit",
                      style: AppTextStyles.whiteFont16Bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> searchAddress(String query) async {
    var storage = await LocalStorage.getInstance();
    SearchAddressResponse res =
        await RestServiceImp.searchAddress(storage.getToken(), query);
    if (res.isSuccess && res.data.isNotEmpty) {
      searchAddressRead.setAddress(res.data);
      searchAddressRead.isDropDownEnable(true);
    }
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
        storage.getToken(), id, vehicleType.label);
    if (res.isSuccess) {
      modelRead.setModels(res.data);
    }
  }

  Future<void> loadColor(int id) async {
    var storage = await LocalStorage.getInstance();
    VehicleColorResponse res =
        await RestServiceImp.getColors(storage.getToken(), id);
    if (res.isSuccess) {
      colorRead.setColors(res.data);
    }
  }

  Future<void> loadAddresses() async {
    var storage = await LocalStorage.getInstance();
    profileStatus = storage.getStatus();
    AddressResponse res =
        await RestServiceImp.getUserAddresses();
    if (res.isSuccess) {
      addressRead.setAddresses(res.data);
    }
    addressRead.setIsLoading(false);
  }

  Widget _buildInputField(IconData icon, String label, String hint, Color bgColor, {bool isDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.white54),
            suffixIcon: isDropdown ? const Icon(Icons.arrow_drop_down, color: Colors.white54) : null,
            label: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
      ),
    );
  }

  Widget firstName(){
    return Expanded(
      child: Container(
        // The "Card Side" color effect is created by this background
        // and the subtle border below
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF252D37), // Card Face Color
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.white10,
              blurRadius: 10,
              offset: Offset(0, 4), // Pushes the shadow down to give depth
            ),
          ],
          // border: Border.all(
          //   color: Colors.white.withOpacity(0.05), // Subtle "edge" light
          //   width: 1,
          // ),
        ),
        child: Row(
          children: [
            // Person icon for Name fields
            const Icon(Icons.person_outline, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "FIRST NAME:",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9, // Slightly smaller for dense rows
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextField(
                    controller: _firstNameController,
                    onChanged: (v) {},
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    cursorColor: Colors.white70,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                      border: InputBorder.none,
                      hintText: "ENTER NAME",
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
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

  Widget lastName(){
    return Expanded(
      child: Container(
        // The "Card Side" color effect is created by this background
        // and the subtle border below
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF252D37), // Card Face Color
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(
          //   color: Colors.white.withOpacity(0.05), // Subtle "edge" light
          //   width: 1,
          // ),
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
            // Person icon for Name fields
            const Icon(Icons.person_outline, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "LAST NAME:",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9, // Slightly smaller for dense rows
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextField(
                    controller: _lastNameController,
                    onChanged: (v) {},
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    cursorColor: Colors.white70,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 2),
                      border: InputBorder.none,
                      hintText: "ENTER NAME",
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
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

  Widget flatWidget(){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF252D37), // Card Face Color
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: Colors.white70, // Side-color light effect
        //   width: 1,
        // ),
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
          // Home icon for address fields
          const Icon(Icons.home_work_outlined, color: Colors.white70, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // RichText allows us to color the '*' differently
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: "* ",
                          style: TextStyle(color: Color(0xFFE55D5D), fontWeight: FontWeight.bold, fontSize: 10)
                      ),
                      TextSpan(
                          text: "FLAT NO / H.NO:",
                          style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _flatNumberController,
                  // Keeping your logic intact
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      return newValue.copyWith(text: newValue.text.toUpperCase());
                    }),
                  ],
                  onChanged: (v) {},
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  cursorColor: Colors.white70,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                    hintText: "ENTER FLAT OR HOUSE NUMBER",
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

  Widget searchSociety(){
    return Column(
      children: [
        // --- SEARCH BAR CONTAINER ---
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF252D37), // Card Face Color
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(
            //   color: Colors.white70, // Side-color light effect
            //   width: 1,
            // ),
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
              const Icon(Icons.search, color: Colors.white70, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "SOCIETY:",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      cursorColor: Colors.white70,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        border: InputBorder.none, // Removed the ugly box border
                        hintText: "SEARCH SOCIETY",
                        hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          searchAddressRead.isDropDownEnable(false);
                          searchAddressRead.clearSelectedAddress();
                        } else if (value.length > 3) {
                          searchAddress(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // --- SEARCH SUGGESTIONS DROP_DOWN ---
        if (searchAddressWatch.showDropdown)
          dropDown()
          // Container(
          //   margin: const EdgeInsets.only(top: 8), // Gap between search and list
          //   constraints: const BoxConstraints(maxHeight: 250), // Limit height
          //   decoration: BoxDecoration(
          //     color: const Color(0xFF2A3441), // Slightly lighter than background
          //     borderRadius: BorderRadius.circular(12),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.4),
          //         blurRadius: 12,
          //         offset: const Offset(0, 6),
          //       ),
          //     ],
          //   ),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(12),
          //     child: ListView.separated(
          //       padding: EdgeInsets.zero,
          //       shrinkWrap: true,
          //       itemCount: searchAddressWatch.suggestions.length,
          //       separatorBuilder: (context, index) => const Divider(
          //         color: Colors.white10,
          //         height: 1,
          //         indent: 16,
          //         endIndent: 16,
          //       ),
          //       itemBuilder: (context, index) {
          //         final suggestion = searchAddressWatch.suggestions[index];
          //         return ListTile(
          //           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //           title: Text(
          //             suggestion.societyName,
          //             style: const TextStyle(color: Colors.white70, fontSize: 14),
          //           ),
          //           subtitle: suggestion.city != null
          //               ? Text(suggestion.city!, style: const TextStyle(color: Colors.white24, fontSize: 11))
          //               : null,
          //           trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 14),
          //           onTap: () {
          //             controller.text = suggestion.societyName;
          //             searchAddressRead.isDropDownEnable(false);
          //             searchAddressRead.setSelectedAddress(suggestion);
          //           },
          //         );
          //       },
          //     ),
          //   ),
          // ),

      ],
    );
  }

  Widget dropDown(){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 8),
      constraints: const BoxConstraints(maxHeight: 280), // Slightly taller for better visibility
      decoration: BoxDecoration(
        // Gradient background gives it a "glass" depth
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A3441),
            Color(0xFF212832),
          ],
        ),
        borderRadius: BorderRadius.circular(16), // Softer corners
        // border: Border.all(color: Colors.white.withOpacity(0.08)), // Subtle "rim" light
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: searchAddressWatch.suggestions.isEmpty
            ? _buildNoResultsView() // Added an empty state
            : Scrollbar(
          thickness: 4,
          radius: const Radius.circular(10),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(), // Premium iOS-style feel
            itemCount: searchAddressWatch.suggestions.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.white70,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final suggestion = searchAddressWatch.suggestions[index];
              return Material(
                color: Colors.transparent,
                child: ListTile(
                  hoverColor: Colors.white10,
                  splashColor: Colors.white70,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on_outlined,
                        color: Colors.white38, size: 18),
                  ),
                  title: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      '${suggestion.societyName},${suggestion.societyLine1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  subtitle: suggestion.city != null
                      ? Text(suggestion.city!,
                      style: const TextStyle(color: Colors.white24, fontSize: 11))
                      : null,
                  trailing: const Icon(Icons.north_west_rounded,
                      color: Colors.white12, size: 16), // "Use suggestion" icon
                  onTap: () {
                    controller.text = suggestion.societyName;
                    searchAddressRead.isDropDownEnable(false);
                    searchAddressRead.setSelectedAddress(suggestion);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

  }
  // Helper for when no matches are found
  Widget _buildNoResultsView() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(Icons.search_off, color: Colors.white24, size: 20),
          SizedBox(width: 12),
          Text("No societies found...",
              style: TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

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
                  value: selectedModel,
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
                      loadColor(selectedModel!.id);
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
                  value: selectedColor,
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

