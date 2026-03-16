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
    searchAddressRead.clearSelectedAddress();
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
    } else if (vehicleNumberController.text.length < 10) {
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
        AddVehicleAndAddressResponse res =
            await RestServiceImp.addVehicleAndAddress(vehicleAndAddress);
        if (res.isSuccess) {
          LocalStorage.setStatus(ProfileStatus.completed.label);
          if(isFistNameUpdated) {
            LocalStorage.setFirstName(firstName!);
            LocalStorage.setLastName(lastName!);
          }
          vehicleRead.addVehicle(res.data.vehicle!);
          Navigator.pop(context);
        }
        CommonUtils.toastMessage(res.message);
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
                /// STEP 1 VEHICLE
                SingleChildScrollView(
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
                              value: selectedBrand,
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
                                setState(() {
                                  selectedModel = v;
                                  loadColor(selectedModel!.id);
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
                                  Expanded(
                                      child: UnderlinedTextField(
                                    colorTheme: ColorTheme.dark,
                                    labelText: "First Name",
                                    controller: _firstNameController,
                                    onChanged: (v) {},
                                  )),

                                  const SizedBox(width: 16),

                                  /// LAST NAME DROPDOWN
                                  Expanded(
                                    child: UnderlinedTextField(
                                      colorTheme: ColorTheme.dark,
                                      labelText: "Last Name",
                                      controller: _lastNameController,
                                      onChanged: (v) {},
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 30),

                            UnderlinedTextField(
                              colorTheme: ColorTheme.dark,
                              labelText: "*Flat No / H.No",
                              controller: _flatNumberController,
                              inputFormatters: [
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  return newValue.copyWith(
                                      text: newValue.text.toUpperCase());
                                }),
                              ],
                              onChanged: (v) {},
                            ),
                            const SizedBox(height: 20),
                            Column(
                              children: [
                                TextField(
                                  controller: controller,
                                  style: AppTextStyles.whiteFont12Bold,
                                  decoration: const InputDecoration(
                                    hintText: "Search Society",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      // setState(() {
                                      //   showDropdown = false;
                                      searchAddressRead.isDropDownEnable(false);
                                      searchAddressRead.clearSelectedAddress();
                                      // });
                                    } else {
                                      if (value.length > 3) {
                                        searchAddress(value);
                                      }
                                    }
                                  },
                                ),
                                if (searchAddressWatch.showDropdown)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B2D42),
                                      // dark background
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: SizedBox(
                                      height: dropdownHeight,
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: searchAddressWatch
                                              .suggestions.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                searchAddressWatch
                                                    .suggestions[index]
                                                    .societyName,
                                                style: AppTextStyles
                                                    .whiteFont12Bold,
                                              ),
                                              onTap: () {
                                                controller.text =
                                                    searchAddressWatch
                                                        .suggestions[index]
                                                        .societyName;
                                                searchAddressRead
                                                    .isDropDownEnable(false);
                                                searchAddressRead
                                                    .setSelectedAddress(
                                                        searchAddressWatch
                                                                .suggestions[
                                                            index]);
                                                // setState(() {
                                                //   showDropdown = false;
                                                // });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
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
}
