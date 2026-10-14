import 'package:dmw/providers/ScheduleProvider.dart';
import 'package:dmw/providers/one_time_service_provider.dart';
import 'package:dmw/utils/custom_button_styles.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/widgets/ots_vehicle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ApiResponse/vehicle_response.dart';
import '../../Apis/RestServiceImp.dart';
import '../../models/service.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../utils/common_utils.dart';
import '../../utils/custom_enums.dart';
import '../../utils/local_storage.dart';
import '../../widgets/vehicle_widget.dart';

class OneTimeBookingScheduleWidget extends StatefulWidget{
  final Service selectedService;

  const OneTimeBookingScheduleWidget({
    super.key,
    required this.selectedService,
  });
  @override
  State<OneTimeBookingScheduleWidget> createState() => _OneTimeBookingScheduleState();
}
class _OneTimeBookingScheduleState extends State<OneTimeBookingScheduleWidget> {
  late VehicleProvider read,watch;
  // Color constants aligned with SelectPlanScreen
  static const Color selectedItemBgColor = Color(0xFFE8F0F6); // Soft blue selection container
  static const Color primaryActiveRed = Colors.red;           // Primary active accent / border
  static const Color cardBorderColor = Color(0xFFE0E0E0);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textMuted = Color(0xFF757575);

  @override
  void initState() {
    // TODO: implement initState
    read = context.read<VehicleProvider>();
    read.setIsLoading(true);
    Future.microtask((){
      loadVehicles();

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    watch = context.watch<VehicleProvider>();


    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        title: const Text(
          'Schedule',
          style: AppTextStyles.primaryFont20Bold,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Overview Badge
                  _buildServiceSummaryBadge(widget.selectedService),
                  const SizedBox(height: 16),

                  // Step 1: Date Section
                  _buildDateSection(context, provider),

                  // Step 2: Time Slot Section (Opens when Date is picked)
                  if (provider.isDateSelected) ...[
                    const SizedBox(height: 16),
                    _buildTimeSlotSection(context, provider),
                  ],

                  // Confirmation preview badge
                  if (provider.isReadyToContinue) ...[
                    const SizedBox(height: 16),
                    _buildSelectionConfirmation(provider),
                  ],

                  const SizedBox(height: 20),
                  if(provider.isReadyToContinue) ...[
                    _vehicles(watch,provider.selectedDateTime,widget.selectedService)
                  ]
                ],
              ),
            ),
          ),
          _buildBottomPromoBar(),
          // _buildBottomContinueSection(context, provider),
        ],
      ),
    );
  }

  // --- Selected Service Header Card ---
  Widget _buildServiceSummaryBadge(Service item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 55,
              height: 55,
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: selectedItemBgColor,
                  child: const Icon(
                    Icons.directions_car,
                    color: AppColors.secondary,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.serviceName,
                  style: AppTextStyles.blackFont16Bold,
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 1: Date Section (Matching SelectPlan Date Container) ---
  Widget _buildDateSection(BuildContext context, ScheduleProvider provider) {
    return _buildCardWrapper(
      title: 'Select Date',
      child: Row(
        children: List.generate(provider.dateLabels.length, (index) {
          final isSelected = provider.selectedDateIndex == index;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 5.0,
                right: index == provider.dateLabels.length - 1 ? 0 : 5.0,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.read<ScheduleProvider>().selectDate(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    // Selected state: #E8F0F6 with primary red accent border
                    color: isSelected ? selectedItemBgColor : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? primaryActiveRed : cardBorderColor,
                      width: isSelected ? 1.6 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    provider.dateLabels[index],
                    style: TextStyle(
                      color: isSelected ? primaryActiveRed : textDark,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // --- Step 2: Time Slot Section ---
  Widget _buildTimeSlotSection(BuildContext context, ScheduleProvider provider) {
    return _buildCardWrapper(
      title: 'Select Start Time',
      child: Column(
        children: [
          // Morning / Afternoon / Evening Period Filter
          Row(
            children: List.generate(provider.periods.length, (index) {
              final isSelected = provider.selectedPeriodIndex == index;
              return Expanded(
                child: InkWell(
                  onTap: () => context.read<ScheduleProvider>().selectPeriod(index),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          provider.periods[index],
                          style: TextStyle(
                            color: isSelected ? primaryActiveRed : textDark,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 2.5,
                        color: isSelected ? primaryActiveRed : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),

          // Time Grid Slots
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.morningSlots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: 1.85,
            ),
            itemBuilder: (context, index) {
              final isSelected = provider.selectedSlotIndex == index;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => context.read<ScheduleProvider>().selectSlot(index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // Selected state: #E8F0F6 with primary red accent border
                    color: isSelected ? selectedItemBgColor : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? primaryActiveRed : cardBorderColor,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    provider.morningSlots[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primaryActiveRed : textDark,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- Whole Date & Time Preview Badge ---
  Widget _buildSelectionConfirmation(ScheduleProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selectedItemBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryActiveRed.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: primaryActiveRed, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              provider.formattedSchedule,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Promo Saving Banner ---
  Widget _buildBottomPromoBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selectedItemBgColor,
        border: Border(
          top: BorderSide(color: cardBorderColor.withOpacity(0.6)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: primaryActiveRed,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'STARTER\nPACK',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 10),
           RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: textDark),
              children: [
                TextSpan(text: 'You are saving '),
                TextSpan(
                  text: '₹347 ',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryActiveRed),
                ),
                TextSpan(text: 'using '),
                TextSpan(
                  text: 'Starter Pack',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryActiveRed),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Bottom Action Navigation Bar ---
  Widget _buildBottomContinueSection(BuildContext context, ScheduleProvider provider) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 16,
              offset: const Offset(0, -3),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: provider.isReadyToContinue
                ? () {
              final scheduledDateTime = provider.selectedDateTime;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Scheduled for: $scheduledDateTime'),
                  backgroundColor: primaryActiveRed,
                ),
              );
            }
                : null,
            style: provider.isReadyToContinue
                ? AppButtonStyles.primaryButtonStyle
                : ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Continue',
              style: provider.isReadyToContinue
                  ? AppTextStyles.whiteFont16Bold
                  : const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Base Card Shell ---
  Widget _buildCardWrapper({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.blackFont16Bold,
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _vehicles(VehicleProvider watch,DateTime? time,Service serviceItem){
    return watch.isLoading?CommonUtils.loader():SingleChildScrollView(
        padding: const EdgeInsets.all(16),
    // child:  watch.vehicles.isEmpty?/*defaultVehicles()*/const Center(child: Text("Please Add Address")):vehicles(watch.vehicles)
    child: vehicles(watch.vehicles,time!,serviceItem)    );
  }


  Widget vehicles(List<Vehicle> vehicles,DateTime time,Service serviceItem){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 4),
        ...List.generate(2*vehicles.length, (index) {
          if(index.isOdd) return const SizedBox(height: 16);
          return vehicles.isEmpty?const Center(child: Text("Please Add Vehicle",style:TextStyle(
              color: AppColors.white
          ) ,)):OtsVehicleWidget(
            vehicle: vehicles[index~/2], time: time,serviceItem: serviceItem,
          );
        }),
      ],
    );
  }

  Future<void> loadVehicles() async {
    var storage = await LocalStorage.getInstance();
    VehicleResponse response =  await RestServiceImp.getUserVehicles(storage.getToken(),VehicleType.car.label);
    if (response.isSuccess) {
      read.setVehicles(response.data);
      read.setIsLoading(false);
    }
  }
}