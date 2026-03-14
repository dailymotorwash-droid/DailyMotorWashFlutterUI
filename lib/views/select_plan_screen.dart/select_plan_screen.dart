import 'dart:ui';

import 'package:car_wash/ApiResponse/plan_response.dart';
import 'package:car_wash/ApiResponse/subscription_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/plan.dart';
import 'package:car_wash/models/subscription.dart';
import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/providers/service_provider.dart';
import 'package:car_wash/providers/user_provider.dart';
import 'package:car_wash/providers/vehicle_provider.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/local_storage.dart';
import 'package:car_wash/views/select_plan_screen.dart/plan_banner_widget.dart';
import 'package:car_wash/widgets/price_row_widget.dart';
import 'package:car_wash/widgets/vehicle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/page_routes.dart';

class SelectPlanScreen extends StatefulWidget {
  final Vehicle vehicle;

  const SelectPlanScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  late ServiceProvider read, watch;
  late UserProvider userRead, userWatch;
  late VehicleProvider vehicleRead, vehicleWatch;

  // late List<Plan> plansList = [
  //   Plan(vehicleType: 'Monthly', amount: 500, discount: 0),
  //   Plan(vehicleType: 'Quartely', amount: 1500, discount: 60),
  //   Plan(vehicleType: 'Half-Yearly', amount: 3000, discount: 240),
  //   Plan(vehicleType: 'Yearly', amount: 6000, discount: 600),
  // ];

  late List<String> planLabels = [
    'Standard',
    'Recommended',
    'Good Deal',
    'Last Chance'
  ];

  int selectPlanIndex = 0;
  late Vehicle _vehicle;

  @override
  void initState() {
    // TODO: implement initState
    _vehicle = widget.vehicle;
    read = context.read<ServiceProvider>();
    userRead = context.read<UserProvider>();
    vehicleRead = context.read<VehicleProvider>();
    Future.microtask(() {
      read.setIsLoading(true);
      vehicleRead.selectVehicle(_vehicle);
      loadServices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<ServiceProvider>();
    vehicleWatch = context.watch<VehicleProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Plan'),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.white, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ]),
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => proceed(watch.planes[selectPlanIndex]),
          style: AppButtonStyles.secondaryButtonStyle,
          child: watch.planes.isEmpty
              ? null
              : Row(
                  children: [
                    Text(
                      '₹${watch.planes[selectPlanIndex].rate - watch.planes[selectPlanIndex].discount} +taxes',
                      style: AppTextStyles.whiteFont12Bold,
                    ),
                    const Spacer(),
                    const Text(
                      'Proceed',
                      style: AppTextStyles.whiteFont16Regular,
                    ),
                  ],
                ),
        ),
      ),
      body: watch.isLoading
          ? CommonUtils.loader()
          : watch.planes.isEmpty
              ? const Center(child: Text("No Plans Found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      VehicleWidget(
                          vehicle: vehicleWatch.selectedVehicle!,
                          isClickable: false),
                      const SizedBox(height: 16),
                      ...List.generate(2 * watch.planes.length - 1, (index) {
                        int actualIndex = index ~/ 2;
                        bool isCurrentPlanSelected =
                            selectPlanIndex == actualIndex;
                        if (index.isOdd) return const SizedBox(height: 16);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              planLabels[actualIndex],
                              style: AppTextStyles.blackFont16Bold,
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectPlanIndex = actualIndex;
                                });
                              },
                              child: PlanBannerWidget(
                                plan: watch.planes[actualIndex],
                                isPlanSelected: isCurrentPlanSelected,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
    );
  }

  Future<void> loadServices() async {
    var storage = await LocalStorage.getInstance();
    PlanResponse response = await RestServiceImp.getUserServices(
        storage.getToken(), _vehicle.vehicleType!, _vehicle.size!);
    if (response.isSuccess) {
      read.setPlans(response.data);
      read.setIsLoading(false);
    }
  }

  void proceed(Plan plan) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double sheetHeight = screenHeight * 0.55;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            /// BLUR BACKGROUND
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),

            /// DRAGGABLE SHEET
            DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.45,
              maxChildSize: 0.85,
              builder: (context, controller) {
                return Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: ListView(
                    controller: controller,
                    children: [
                      /// DRAG HANDLE
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

                      /// HEADER
                      Row(
                        children: [
                          Icon(Icons.arrow_back, size: screenWidth * 0.06),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            "Payment",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.004,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(
                              "₹0",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.025),

                      /// VEHICLE BOX
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

                            SizedBox(height: screenHeight * 0.005),

                            Text(
                              '${_vehicle.color}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                              ),
                            ),

                            const Divider(),

                            PriceRowWidget(
                              title:
                                  '${CommonUtils.cycle(plan.cycle)} ${CommonUtils.vehicleType(_vehicle.vehicleType!)} wash',
                              value: '${plan.rate}',
                            ),
                            PriceRowWidget(
                              title: 'discount',
                              value: '${plan.discount}',
                            ),
                            PriceRowWidget(
                              title: 'Amount',
                              value: '${plan.rate - plan.discount}',
                            ),
                            // PriceRowWidget(title: 'Taxes',value: '₹ 205',),

                            const Divider(),
                            PriceRowWidget(
                                title: 'Total',
                                value: '₹ ${plan.rate - plan.discount}',
                                isBold: true),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        child:ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.018,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => subscribe(plan),
                          child:  vehicleWatch.isLoading
                              ? CommonUtils.loader()
                              :  const Text("Subscribe",
                                  style: AppTextStyles.whiteFont12Bold),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      // Center(
                      //   child: Text(
                      //     "Low Balance!",
                      //     style: TextStyle(
                      //       color: Colors.red,
                      //       fontSize: screenWidth * 0.035,
                      //     ),
                      //   ),
                      // ),

                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                );
              },
            ),

            /// FLOATING CLOSE BUTTON
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
            )
          ],
        );
      },
    );
  }

  Future<void> subscribe(Plan plan) async {
    vehicleRead.setIsLoading(true);
    String? vehicleId = vehicleRead.selectedVehicle?.id;
    Subscription subscription = Subscription(
        vehicleId: vehicleId!,
        rateId: plan.id,
        rate: plan.rate,
        discount: plan.discount,
        paymentMethod: 'UPI');
    print(subscription.toJson());
    SubscriptionResponse response = await RestServiceImp.subscribe(subscription);
    if(response.isSuccess){

      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeScreen,(Route<dynamic> route) => false);
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute<void>(builder: (context) => const HomeScreen())
      //       // (Route<dynamic> route) => false, // This predicate removes all routes
      // );

    }
    vehicleRead.setIsLoading(false);
    CommonUtils.toastMessage(response.message);
  }
}
