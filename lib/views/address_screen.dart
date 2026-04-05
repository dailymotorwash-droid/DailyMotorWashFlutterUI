import 'package:dmw/ApiResponse/address_response.dart';
import 'package:dmw/utils/custom_button_styles.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:dmw/widgets/underlined_text_field.dart';
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
  final String? vehicleId;
  final Address? address;
  final String from;
  const AddressScreen({super.key, this.vehicleId,required this.from,this.address,});

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
  late Address _address;
  late String _from;
  @override
  void initState() {
    // TODO: implement initState
    searchAddressRead = context.read<SearchAddressProvider>();
    addressRead = context.read<AddressProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchAddressRead.clearSelectedAddress();

    });
    _from = widget.from;
    if(_from=="UPDATE"){
      _address = widget.address!;
      controller.text = _address.addressLine1!;
      _flatNumberController.text = _address.houseNo!;
    }else{
      _vehicleId = widget.vehicleId!;
    }
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

            flatWidget(),
            searchSociety(),
            const SizedBox(height: 20),
            if(searchAddressWatch.selectedAddress!=null)
              showAddWidget(),


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
                  if(_from=="UPDATE"){
                    requestToUpdate();
                  }else {
                    addAddress();
                  }
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

  Future<void> requestToUpdate() async{

    if (_flatNumberController.text.isNotEmpty) {
      if (searchAddressWatch.selectedAddress != null) {
        MasterAddress? address = searchAddressWatch.selectedAddress;
        if(_address.masterAddressId == address?.id){
          CommonUtils.toastMessage("You have selected previous address");
          return;
        }
        Address add = Address(
            id: _address.id,
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
            // vehicleId: _vehicleId
        );
        AddressResponse res =
        await RestServiceImp.updateUserAddress(add);

        CommonUtils.toastMessage(res.message);
        Navigator.pop(context);
      } else {
        CommonUtils.toastMessage("Please Select Society");
      }
    } else {
      CommonUtils.toastMessage("Please Fill Flat No./H.No.");
    }


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
                  maxLength: 10,
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
  String getFormattedAddress(MasterAddress? address) {
    if (address == null) return '';

    // Filter out empty or null strings to avoid double commas like ", ,"
    final parts = [
      address.societyName,
      address.societyLine1,
      address.societyLine2,
      address.societyLine3,
      address.city,
      address.district,
      address.state,
    ].where((s) => s != null && s.isNotEmpty).toList();

    String base = parts.join(', ');

    // Add PinCode with the specific dash formatting
    if (address.pinCode != null && address.pinCode!.isNotEmpty) {
      base += ' - ${address.pinCode}';
    }

    return base;
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

  Widget showAddWidget(){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252D37),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Keeps icon and text centered
        children: [
          const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              getFormattedAddress(searchAddressWatch.selectedAddress),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4, // Improved line spacing for multi-line addresses
              ),
              // Prevents the UI from breaking if the address is massive
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}

