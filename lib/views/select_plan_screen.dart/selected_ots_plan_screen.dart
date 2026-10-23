import 'dart:core';
import 'dart:ui';

import 'package:dmw/ApiResponse/Response.dart';
import 'package:dmw/ApiResponse/plan_response.dart';
import 'package:dmw/ApiResponse/razorpay_response.dart';
import 'package:dmw/ApiResponse/user_profile_response.dart';
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:dmw/models/address.dart';
import 'package:dmw/models/plan.dart';
import 'package:dmw/models/razorpay.dart' as razorpayModel;
import 'package:dmw/models/vehicle.dart';
import 'package:dmw/providers/ScheduleProvider.dart';
import 'package:dmw/providers/one_time_service_provider.dart';
import 'package:dmw/providers/service_provider.dart';
import 'package:dmw/providers/user_provider.dart';
import 'package:dmw/providers/vehicle_provider.dart';
import 'package:dmw/utils/common_utils.dart';
import 'package:dmw/utils/custom_button_styles.dart';
import 'package:dmw/utils/custom_colors.dart';
import 'package:dmw/utils/custom_text_styles.dart';
import 'package:dmw/utils/local_storage.dart';
import 'package:dmw/utils/page_routes.dart';
import 'package:dmw/widgets/price_row_widget.dart';
import 'package:dmw/widgets/vehicle_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/OneTimeBookingRequest.dart';
import '../../models/schedule_slot.dart';
import '../../models/service.dart';

class SelectedOtsPlanScreen extends StatefulWidget {
  final Vehicle vehicle;
  final Address address;
  final Service serviceItem;
  final ScheduleSlot selectedSlot;
  final String selectedSlotDate;
  const SelectedOtsPlanScreen({
    super.key,
    required this.vehicle,
    required this.address,
    required this.serviceItem, required this.selectedSlot, required this.selectedSlotDate,
  });

  @override
  State<SelectedOtsPlanScreen> createState() => _SelectedOtsPlanScreenState();
}

class _SelectedOtsPlanScreenState extends State<SelectedOtsPlanScreen> {
  late ServiceProvider read, watch;
  late UserProvider userRead, userWatch;
  late VehicleProvider vehicleRead, vehicleWatch;

  late Vehicle _vehicle;
  late Address _address;
  late Service _serviceItem;
  late Razorpay _razorpay;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    CommonUtils.init(context);

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _vehicle = widget.vehicle;
    _address = widget.address;
    _serviceItem = widget.serviceItem;

    read = context.read<ServiceProvider>();
    userRead = context.read<UserProvider>();
    vehicleRead = context.read<VehicleProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      read.clearPlans();
    });

    Future.microtask(() {
      read.setIsLoading(true);
      vehicleRead.selectVehicle(_vehicle);
      loadServices();
    });
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<ServiceProvider>();
    vehicleWatch = context.watch<VehicleProvider>();
    userWatch = context.watch<UserProvider>();
    final scheduleWatch = context.watch<ScheduleProvider>();

    // Single active plan for this service
    final Plan? currentPlan = watch.planes.isNotEmpty ? watch.planes.first : null;
    final double currentTotal = currentPlan != null
        ? (currentPlan.rate - currentPlan.discount).toDouble()
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.white,
        title: const Text('Service Details', style: AppTextStyles.primaryFont20Bold),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                spreadRadius: 0,
                blurRadius: 16,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: currentPlan != null ? () => proceed(currentPlan) : null,
            style: AppButtonStyles.primaryButtonStyle,
            child: currentPlan == null
                ? null
                : Row(
              children: [
                Text(
                  '₹${currentTotal.toInt()}',
                  style: AppTextStyles.whiteFont16Bold,
                ),
                const Spacer(),
                const Text('Proceed', style: AppTextStyles.whiteFont16Bold),
              ],
            ),
          ),
        ),
      ),
      body: watch.isLoading
          ? CommonUtils.loader()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Card
            VehicleWidget(
              vehicle: vehicleWatch.selectedVehicle ?? _vehicle,
              isClickable: false,
              isEditable: false,
                isSubscription:false,
                selectedService: widget.serviceItem,
            ),
            const SizedBox(height: 16),

            // Simple Service & Schedule Card
            _buildServiceDetailCard(scheduleWatch, currentPlan),
          ],
        ),
      ),
    );
  }

  // --- Clean Single Service Overview Card ---
  // Widget _buildServiceDetailCard(ScheduleProvider scheduleWatch, Plan? plan) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: const Color(0xFFE0E0E0)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: SizedBox(
  //                 width: 65,
  //                 height: 65,
  //                 child: Image.network(
  //                   _serviceItem.image,
  //                   fit: BoxFit.cover,
  //                   errorBuilder: (_, __, ___) => Container(
  //                     color: const Color(0xFFE8F0F6),
  //                     child: const Icon(
  //                       Icons.directions_car,
  //                       color: AppColors.secondary,
  //                       size: 32,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 14),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(_serviceItem.serviceName, style: AppTextStyles.blackFont16Bold),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     _serviceItem.description,
  //                     style: const TextStyle(fontSize: 12, color: Color(0xFF757575), height: 1.3),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //         if (scheduleWatch.formattedSchedule.isNotEmpty) ...[
  //           const Divider(height: 24),
  //           Row(
  //             children: [
  //               const Icon(Icons.access_time_filled, size: 18, color: Colors.red),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: Text(
  //                   scheduleWatch.formattedSchedule,
  //                   style: const TextStyle(
  //                     fontSize: 13,
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xFF1E1E1E),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //
  //         if (plan != null) ...[
  //           const Divider(height: 24),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text("Service Price", style: AppTextStyles.blackFont16Regular),
  //               Text("₹${plan.rate}", style: AppTextStyles.blackFont16Bold),
  //             ],
  //           ),
  //           if (plan.discount > 0) ...[
  //             const SizedBox(height: 4),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text("Discount", style: TextStyle(color: Colors.green, fontSize: 14)),
  //                 Text("-₹${plan.discount}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //           ],
  //         ],
  //       ],
  //     ),
  //   );
  // }

  // --- Clean Single Service Overview Card ---
  Widget _buildServiceDetailCard(ScheduleProvider scheduleWatch, Plan? plan) {
    // Safe extraction / defaults from API response fields
    final double rate = (plan?.rate ?? 0.0).toDouble();
    final double baseRate = (plan?.baseRate ?? rate).toDouble();
    final double discount = (plan?.discount ?? 0.0).toDouble();
    final double finalAmount = (rate - discount).clamp(0.0, double.infinity);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Service Title, Image & Subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: Image.network(
                    _serviceItem.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE8F0F6),
                      child: const Icon(
                        Icons.directions_car,
                        color: AppColors.secondary,
                        size: 32,
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
                      plan?.serviceName ?? _serviceItem.serviceName,
                      style: AppTextStyles.blackFont16Bold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _serviceItem.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                        height: 1.3,
                      ),
                    ),
                    // Vehicle Size & Type chips if present
                    if (plan != null) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          // if (plan.vehicleSize != null)
                          //   _buildDetailChip(plan.vehicleSize.toString()),
                          if (plan.vehicleType != null)
                            _buildDetailChip(plan.vehicleType.toString()),
                          if (plan.cycle != null)
                            _buildDetailChip(plan.cycle.toString().replaceAll('_', ' ')),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // 2. Schedule Slot Preview
          if (scheduleWatch.formattedSchedule.isNotEmpty) ...[
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time_filled, size: 18, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    scheduleWatch.formattedSchedule,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
              ],
            ),
          ],

          // 3. Pricing Breakdown from API Response
          if (plan != null) ...[

            // Base Rate Row (shown with strikethrough if different from rate or if discounted)
            // if (baseRate > rate) ...[
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text("Service Rate", style: TextStyle(fontSize: 14, color: Color(0xFF757575))),
            //       Text(
            //         "₹${baseRate.toStringAsFixed(0)}",
            //         style: const TextStyle(
            //           fontSize: 14,
            //           color: Color(0xFF9E9E9E),
            //           decoration: TextDecoration.lineThrough,
            //         ),
            //       ),
            //     ],
            //   ),
            //   const SizedBox(height: 6),
            // ],



            // Discount Row (if applicable)
            if (discount > 0) ...[
              const Divider(height: 24),

              // Service Rate Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Service Rate", style: AppTextStyles.blackFont16Regular),
                  Text("₹${rate.toStringAsFixed(0)}", style: AppTextStyles.blackFont16Bold),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Discount", style: TextStyle(color: Colors.green, fontSize: 14)),
                  Text(
                    "-₹${discount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],

            const Divider(height: 20),

            // Total Payable
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                Text(
                  "₹${finalAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

// Helper chip badge for vehicle size and cycle
  Widget _buildDetailChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2C3040),
        ),
      ),
    );
  }

  Future<void> loadServices() async {
    final storage = await LocalStorage.getInstance();
    final PlanResponse response = await RestServiceImp.getUserOneTimeServices(
      storage.getToken(),
      _vehicle.vehicleType!,
      _vehicle.size!,
      _address.masterAddressId!,'ONE_TIME',_serviceItem.id,
    );
    if (response.isSuccess) {
      read.setPlans(response.data);
      read.setIsLoading(false);
    }
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final UserProfileResponse userProfileResponse = await RestServiceImp.getProfile();
    if (userProfileResponse.isSuccess) {
      userRead.login(userProfileResponse.data);
    }
  }

  // --- Payment Bottom Sheet ---
  void proceed(Plan plan) {
    read.selectPlan(plan);
    vehicleRead.setIsLoading(false);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double sheetHeight = screenHeight * 0.55;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            // BLUR BACKGROUND
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),

            // DRAGGABLE SHEET
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.45,
              maxChildSize: 0.85,
              builder: (context, controller) {
                final userPoints = userWatch.user?.points ?? 0;
                final totalPayable = (plan.rate - plan.discount - userPoints).clamp(0, double.infinity);

                return Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      // DRAG HANDLE
                      Center(
                        child: Container(
                          width: screenWidth * 0.12,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // HEADER
                      Row(
                        children: [
                          Text(
                            "Payment",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.025),

                      // VEHICLE & SERVICE DETAILS BOX
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8F0F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_vehicle.brand} ${_vehicle.model} (${_vehicle.registrationNumber})',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _serviceItem.serviceName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Divider(),
                            PriceRowWidget(
                              title: '${_serviceItem.serviceName} - Wash',
                              value: '₹${plan.rate}',
                            ),
                            if(plan.discount>0)...[
                              PriceRowWidget(
                                title: 'discount',
                                value: '${plan.discount}',
                              ),
                            ],
                            // PriceRowWidget(
                            //   title: 'Points',
                            //   value: '₹$userPoints',
                            // ),
                            const Divider(),
                            PriceRowWidget(
                              title: 'Total',
                              value: '₹$totalPayable',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // BUTTON
                      Consumer<VehicleProvider>(
                        builder: (context, vehicleWatch, _) {
                          return vehicleWatch.isLoading
                              ? CommonUtils.loader()
                              : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.018,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () => createRazorpayOrder(plan),
                              child: const Text(
                                "Book Now",
                                style: AppTextStyles.whiteFont12Bold,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                );
              },
            ),

            // FLOATING CLOSE BUTTON
            Positioned(
              bottom: sheetHeight + 25,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> createRazorpayOrder(Plan plan) async {
    vehicleRead.setIsLoading(true);

    double amount = (plan.rate - plan.discount).toDouble();
    // final points = userWatch.user?.points ?? 0;
    // if (points > 0) {
    //   amount = (amount - points).clamp(0, double.infinity);
    // }

    final Map<String, dynamic> data = {
      "amount": amount,
      "userId": userWatch.user?.id,
    };

    final RazorpayResponse response = await RestServiceImp.createRazorpayOrder(data);
    openCheckout(amount, response.data.id);
  }

  void openCheckout(double amount, String id) async {
    final options = {
      'key': 'rzp_live_ShK7walg82j14u',
      'amount': amount * 100,
      'name': 'Daily Motor Wash',
      'description': 'One-Time Service: ${_serviceItem.serviceName}',
      'order_id': id,
      'prefill': {
        'contact': userWatch.user?.phone,
        'email': userWatch.user?.email,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      vehicleRead.setIsLoading(false);
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    verifyPayment(response.signature, response.orderId, response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CommonUtils.toastMessage("Payment Failed");
    vehicleRead.setIsLoading(false);
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeScreen,
          (Route<dynamic> route) => false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    vehicleRead.setIsLoading(false);
  }

  Future<void> verifyPayment(
      String? signature,
      String? orderId,
      String? paymentId,
      ) async {
    final Map<String, dynamic> data = {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": signature,
    };
    final Response response = await RestServiceImp.verifyPayment(data);
    if (response.isSuccess) {
      bookOneTimeService(paymentId);
    }
    vehicleRead.setIsLoading(false);
  }

  Future<void> bookOneTimeService(String? paymentId) async {


    final bookingRequest = OneTimeBookingRequest(
      vehicleId: (_vehicle.id ?? '').toString(),
      serviceId: _serviceItem.id,
      rateId: watch.planes.first.id,
      rate: read.planes[0].rate.toDouble(),
      discount: read.planes[0].discount.toDouble(),
      bookingDate: widget.selectedSlotDate,
      slotStartTime: widget.selectedSlot.startTime,
      slotEndTime: widget.selectedSlot.endTime,
      slotLabel: widget.selectedSlot.label,
      paymentId: paymentId!,
      slotInventoryId: widget.selectedSlot.slotInventoryId,
      addressId: widget.address.id!,

    );

    final Response response = await RestServiceImp.bookOneTimeService(bookingRequest);
    if (response.isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeScreen,
            (Route<dynamic> route) => false,
      );
    } else {
      CommonUtils.toastMessage(response.message);
    }
  }
}