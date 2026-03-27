import 'dart:ui';

import 'package:car_wash/ApiResponse/plan_response.dart';
import 'package:car_wash/ApiResponse/razorpay_response.dart';
import 'package:car_wash/ApiResponse/subscription_response.dart';
import 'package:car_wash/ApiResponse/user_profile_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/address.dart';
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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../ApiResponse/Response.dart';
import '../../models/razorpay.dart' as razorpayModel;
import '../../providers/subscription_provider.dart';
import '../../utils/page_routes.dart';

class SelectPlanScreen extends StatefulWidget {
  final Vehicle vehicle;
  final Address address;

  const SelectPlanScreen({
    super.key,
    required this.vehicle,
    required this.address,
  });

  @override
  State<SelectPlanScreen> createState() => _SelectPlanScreenState();
}

class _SelectPlanScreenState extends State<SelectPlanScreen> {
  late ServiceProvider read, watch;
  late UserProvider userRead, userWatch;
  late VehicleProvider vehicleRead, vehicleWatch;
  late SubscriptionProvider subscriptionRead, subscriptionWatch;

  // late List<Plan> plansList = [
  //   Plan(vehicleType: 'Monthly', amount: 500, discount: 0),
  //   Plan(vehicleType: 'Quartely', amount: 1500, discount: 60),
  //   Plan(vehicleType: 'Half-Yearly', amount: 3000, discount: 240),
  //   Plan(vehicleType: 'Yearly', amount: 6000, discount: 600),
  // ];
  DateTime? selectedDate;

  late List<String> planLabels = [
    'Standard',
    'Recommended',
    'Good Deal',
    'Last Chance'
  ];

  int selectPlanIndex = 0;
  late Vehicle _vehicle;
  late int referredBy;
  late bool isPointsAvail;
  late int points;
  late Address _address;
  late Plan _plane;
  late Razorpay _razorpay;
  late razorpayModel.Razorpay _razorpayModel;

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();

    // Setup listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _vehicle = widget.vehicle;
    _address = widget.address;
    read = context.read<ServiceProvider>();
    userRead = context.read<UserProvider>();
    vehicleRead = context.read<VehicleProvider>();
    subscriptionRead = context.read<SubscriptionProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscriptionRead.clearStartDate();
      read.clearPlans();
    });
    Future.microtask(() {
      read.setIsLoading(true);
      vehicleRead.selectVehicle(_vehicle);
      loadServices();
      loadUserDetails();
      checkFirstOrExpireSubscription();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<ServiceProvider>();
    vehicleWatch = context.watch<VehicleProvider>();
    userWatch = context.watch<UserProvider>();
    subscriptionWatch = context.watch<SubscriptionProvider>();
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
                        isClickable: false,
                        isEditable: false,
                      ),
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
        storage.getToken(),
        _vehicle.vehicleType!,
        _vehicle.size!,
        _address.masterAddressId!);
    if (response.isSuccess) {
      read.setPlans(response.data);
      read.setIsLoading(false);
    }
  }

  void proceed(Plan plan) {
    // selectedDate = null;
    read.selectPlan(plan);
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
                          // Icon(Icons.arrow_back, size: screenWidth * 0.06),
                          // SizedBox(width: screenWidth * 0.03),
                          Text(
                            "Payment",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: screenWidth * 0.03,
                          //     vertical: screenHeight * 0.004,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20),
                          //     border: Border.all(color: Colors.red),
                          //   ),
                          //   child: Text(
                          //     "₹0",
                          //     style: TextStyle(
                          //       color: Colors.red,
                          //       fontSize: screenWidth * 0.035,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),

                      /// Date

                      subscriptionWatch.selectedSubscription != null
                          ? Container()
                          : SizedBox(height: screenHeight * 0.025),

                      Consumer<SubscriptionProvider>(
                        builder: (context, subscriptionWatch, child) {
                          return subscriptionWatch.selectedSubscription != null
                              ? Container()
                              : GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate =
                                        await pickDate(context);

                                    if (pickedDate != null) {
                                      context
                                          .read<SubscriptionProvider>()
                                          .setSelectedStartDate(pickedDate);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffE8F0F6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      subscriptionWatch.selectedStartDate ==
                                              null
                                          ? "Select Date"
                                          : DateFormat('dd MMM yyyy').format(
                                              subscriptionWatch
                                                  .selectedStartDate!,
                                            ),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                );
                        },
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
                              title: 'points',
                              value: '${userWatch.user!.points!}',
                            ),
                            // PriceRowWidget(
                            //   title: 'Amount',
                            //   value: '${plan.rate - plan.discount-userWatch.user!.points!}',
                            // ),
                            // PriceRowWidget(title: 'Taxes',value: '₹ 205',),

                            const Divider(),
                            PriceRowWidget(
                                title: 'Total',
                                value:
                                    '₹ ${plan.rate - plan.discount - userWatch.user!.points!}',
                                isBold: true),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      /// BUTTON
                      SizedBox(
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
                          child: vehicleWatch.isLoading
                              ? CommonUtils.loader()
                              : const Text("Subscribe",
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

  Future<DateTime?> pickDate(BuildContext context) async {
    DateTime now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      // disables past dates
      lastDate: DateTime(now.year + 5),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red, // header + button color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    // read.setSelectedStartDate(pickedDate!);
    return pickedDate;
  }

  // Future<void> subscribe(Plan plan) async {
  //   // vehicleRead.setIsLoading(true);
  //   String? vehicleId = vehicleRead.selectedVehicle?.id;
  //   Subscription subscription = Subscription(
  //       vehicleId: vehicleId!,
  //       rateId: plan.id,
  //       rate: plan.rate,
  //       discount: plan.discount,
  //       paymentMethod: 'UPI',
  //       referredBy: userWatch.user?.referredBy,
  //       addressId: _address.id,
  //       isPointsAvail:userWatch.user?.points!=0?true:false,
  //       startDate:subscriptionWatch.selectedStartDate
  //
  //   );
  //   print(subscription.toJson());
  //   SubscriptionResponse response = await RestServiceImp.subscribe(subscription);
  //   if(response.isSuccess){
  //
  //     Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeScreen,(Route<dynamic> route) => false);
  //     // Navigator.pushAndRemoveUntil(
  //     //   context,
  //     //   MaterialPageRoute<void>(builder: (context) => const HomeScreen())
  //     //       // (Route<dynamic> route) => false, // This predicate removes all routes
  //     // );
  //
  //   }
  //   vehicleRead.setIsLoading(false);
  //   CommonUtils.toastMessage(response.message);
  // }

  Future<void> loadUserDetails() async {
    UserProfileResponse userProfileResponse = await RestServiceImp.getProfile();
    if (userProfileResponse.isSuccess) {
      userRead.login(userProfileResponse.data);
      // isPointsAvail = userProfileResponse.data.points!=0?true:false;
      // referredBy = userProfileResponse.data.referredBy!;
      // points = userProfileResponse.data.points!;
    }
  }

  Future<void> checkFirstOrExpireSubscription() async {
    SubscriptionResponse response =
        await RestServiceImp.checkFirstOrExpireSubscription(
            _address.id!, _vehicle.id!);
    if (response.isSuccess && response.data != null) {
      subscriptionRead.selectSubscription(response.data!);
    }
  }

  Future<void> createRazorpayOrder(Plan plan) async {
    double amount = plan.rate - plan.discount;
    if (userWatch.user?.points != 0) {
      amount = amount - userWatch.user!.points!;
    }
    Map<String, dynamic> data = {
      "amount": amount,
      "userId": userWatch.user?.id
    };

    RazorpayResponse response = await RestServiceImp.createRazorpayOrder(data);
    openCheckout(amount,response.data.id);


    // Navigator.push(
    //     context, MaterialPageRoute(builder:
    //     (context) =>  RazorpayPage(amount:amount,subscription:subscription,user:userWatch.user!,razorpay: response.data,),));
  }

  // This is what opens the Razorpay UI
  void openCheckout(double amount, String id) async {
    // Note: In a real app, 'order_id' comes from your Spring Boot API
    var options = {
      'key': 'rzp_test_SVjbFWBpXVoyC0',
      'amount': amount * 100, // Rs 500
      'name': 'Daily Motor Wash',
      'description': 'Payment for User #${userWatch.user?.id}',
      'order_id': id, // Get this from your backend
      'prefill': {'contact': userWatch.user?.phone, 'email': userWatch.user?.email}
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Always clear listeners to avoid memory leaks
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // response.paymentId, response.orderId, response.signature
    verifyPayment(response.signature, response.orderId, response.paymentId);
    print("Success: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // response.code, response.message
    CommonUtils.toastMessage("Payment Failed");
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.homeScreen, (Route<dynamic> route) => false);
    print("Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  Future<void> verifyPayment(
      String? signature, String? orderId, String? paymentId) async {
    Map<String, dynamic> data = {
      "razorpay_order_id": orderId,
      "razorpay_payment_id": paymentId,
      "razorpay_signature": signature
    };
    Response response = await RestServiceImp.verifyPayment(data);
    if (response.isSuccess) {
      subscribe(paymentId);
    }
  }

  Future<void> subscribe(String? paymentId) async {
    String? vehicleId = vehicleRead.selectedVehicle?.id;
    Subscription subscription = Subscription(
        vehicleId: vehicleId!,
        rateId: watch.selectedPlan!.id,
        rate: watch.selectedPlan!.rate,
        discount: watch.selectedPlan!.discount,
        paymentMethod: 'UPI',
        referredBy: userWatch.user?.referredBy,
        addressId: _address.id,
        isPointsAvail: userWatch.user?.points != 0 ? true : false,
        startDate: subscriptionWatch.selectedStartDate,
        paymentId: paymentId);
    print(subscription.toJson());
    SubscriptionResponse response =
        await RestServiceImp.subscribe(subscription);
    if (response.isSuccess) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.homeScreen, (Route<dynamic> route) => false);
    }
    CommonUtils.toastMessage(response.message);
  }
}
