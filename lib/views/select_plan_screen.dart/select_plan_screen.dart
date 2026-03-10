import 'package:car_wash/ApiResponse/plan_response.dart';
import 'package:car_wash/Apis/RestServiceImp.dart';
import 'package:car_wash/models/vehicle.dart';
import 'package:car_wash/providers/service_provider.dart';
import 'package:car_wash/utils/common_utils.dart';
import 'package:car_wash/utils/custom_button_styles.dart';
import 'package:car_wash/utils/custom_colors.dart';
import 'package:car_wash/utils/custom_text_styles.dart';
import 'package:car_wash/utils/local_storage.dart';
import 'package:car_wash/views/select_plan_screen.dart/plan_banner_widget.dart';
import 'package:car_wash/widgets/vehicle_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late ServiceProvider read,watch;
  // late List<Plan> plansList = [
  //   Plan(vehicleType: 'Monthly', amount: 500, discount: 0),
  //   Plan(vehicleType: 'Quartely', amount: 1500, discount: 60),
  //   Plan(vehicleType: 'Half-Yearly', amount: 3000, discount: 240),
  //   Plan(vehicleType: 'Yearly', amount: 6000, discount: 600),
  // ];

  late List<String> planLabels = ['Standard', 'Recommended', 'Good Deal', 'Last Chance'];

  int selectPlanIndex = 0;
  late Vehicle _vehicle;
  @override
  void initState() {
    // TODO: implement initState
    _vehicle = widget.vehicle;
    read = context.read<ServiceProvider>();
    Future.microtask(() {
      read.setIsLoading(true);
      loadServices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watch = context.watch<ServiceProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Select Plan'),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow (
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ]
        ),
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          style: AppButtonStyles.secondaryButtonStyle,
          child: Row(
            children: [
              Text(
                '₹${watch.planes[selectPlanIndex].rate - watch.planes[selectPlanIndex].discount} +taxes',
                style: AppTextStyles.whiteFont12Bold,
              ),
              const Spacer(),
              const Text('Proceed', style: AppTextStyles.whiteFont16Regular,),
            ],
          ),
        ),
      ),
      body: watch.isLoading?CommonUtils.loader():watch.planes.isEmpty?null:SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            VehicleWidget(vehicle: widget.vehicle, isClickable: false),
            const SizedBox(height: 16),
            ...List.generate(2*watch.planes.length-1, (index) {
              int actualIndex = index~/2;
              bool isCurrentPlanSelected = selectPlanIndex == actualIndex;
              if(index.isOdd) return const SizedBox(height: 16);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(planLabels[actualIndex], style: AppTextStyles.blackFont16Bold,),
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
    PlanResponse response = await RestServiceImp.getUserServices(storage.getToken(), _vehicle.vehicleType!, _vehicle.size!);
    if(response.isSuccess){
      read.setPlans(response.data);
      read.setIsLoading(false);
    }
  }
}