import 'package:car_wash/ApiResponse/address_response.dart';
import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/page_routes.dart';
import 'package:car_wash/widgets/underlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../ApiResponse/search_address_response.dart';
import '../Apis/RestServiceImp.dart';
import '../models/address.dart';
import '../models/master_address.dart';
import '../providers/address_provider.dart';
import '../providers/search_address_provider.dart';
import '../utils/common_utils.dart';
import '../utils/custom_enums.dart';
import '../utils/local_storage.dart';

class AddressScreen extends StatefulWidget {
  final String vehicleId;
  const AddressScreen({super.key,required this.vehicleId});

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
  final TextEditingController controller = TextEditingController();

  int _selectedAddressTypeIndex = -1;
  final List<String> addressTypeOptions = ["HOME", "WORK", "OTHER"];

  late SearchAddressProvider searchAddressRead, searchAddressWatch;
  late AddressProvider addressRead, addressWatch;
  late String _vehicleId;
  @override
  void initState() {
    // TODO: implement initState
    searchAddressRead = context.read<SearchAddressProvider>();
    addressRead = context.read<AddressProvider>();
    searchAddressRead.clearSelectedAddress();
    _vehicleId = widget.vehicleId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    searchAddressWatch = context.watch<SearchAddressProvider>();
    addressWatch = context.watch<AddressProvider>();
    double itemHeight = 50;
    double maxHeight = 200;
    double dropdownHeight =
    (searchAddressWatch.suggestions.length * itemHeight) > maxHeight
        ? maxHeight
        : searchAddressWatch.suggestions.length * itemHeight;
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Add Address', style: AppTextStyles.whiteFont20Regular),
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          // scrollDirection: Axis.vertical,
        child: Column(
          children: [

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


          ],
        )


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
                  addAddress();
                },
                child: const Text("Save",style: AppTextStyles.whiteFont16Bold,),
              ),
            ),
          ),
        )

    );
  }

  Widget oldUi(){
    return
    Column(
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
    );

  }
  static String? _handleEmptyFieldValidation(value) {
    if(value != null && value.isEmpty) {
      return "Above field cannot be empty";
    }

    return null;
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
  void _handleAddressFormSubmit() {
  
      Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.homeScreen, (Route<dynamic> route) => false);
  }

  Future<void> addAddress() async {
    if (_flatNumberController.text.isNotEmpty) {
      if (searchAddressWatch.selectedAddress != null) {
        MasterAddress? address = searchAddressWatch.selectedAddress;
        Address add = Address(
            houseNo: _flatNumberController.text,
            addressLine1: '${address?.societyName}' ,
            addressLine2: address?.societyLine1,
            addressLine3: address?.societyLine2,
            addressLine4: address?.societyLine3,
            pinCode: address?.pinCode,
            district: address?.district,
            city: address?.city,
            masterAddressId: searchAddressWatch.selectedAddress?.id,
            state: address?.state,
          vehicleId: _vehicleId
        );
        AddressResponse res =
        await RestServiceImp.addUserAddress(add);
        if (res.isSuccess) {
          Navigator.pop(context);
          addressRead.addAddresses(res.address);
        }
        CommonUtils.toastMessage(res.message);
      } else {
        CommonUtils.toastMessage("Please Select Society");
      }
    } else {
      CommonUtils.toastMessage("Please Fill Flat No./H.No.");
    }

  }
}

