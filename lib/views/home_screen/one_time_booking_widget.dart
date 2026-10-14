import 'package:dmw/ApiResponse/services_response.dart';
import 'package:dmw/models/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Apis/RestServiceImp.dart';
import '../../providers/one_time_service_provider.dart';
import 'service_card_widget.dart';
class OneTimeBookingWidget extends StatefulWidget{
  const OneTimeBookingWidget({super.key});

  @override
  State<OneTimeBookingWidget> createState() => _OneTimeBookingState();
}
class _OneTimeBookingState extends State<OneTimeBookingWidget> with AutomaticKeepAliveClientMixin{

  late OneTimeServiceProvider read,watch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read = context.read<OneTimeServiceProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadServices();
    });
    // Future.microtask((){
    //   loadServices();
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final watch = context.watch<OneTimeServiceProvider>();
// Determine if there is an odd item left at the end
    final bool hasOddLastItem = watch.services.length % 2 != 0;

    // Grid takes all even pairs (e.g., 4 items if length is 5; all 6 items if length is 6)
    final int gridItemCount = hasOddLastItem ? watch.services.length - 1 : watch.services.length;
    final List<Service> gridItems = watch.services.sublist(0, gridItemCount);

    // The leftover item to span full width (null if count is even)
    final Service? fullWidthItem = hasOddLastItem ? watch.services.last : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pastel Gradient Banner Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFAA8A), // Peach
                Color(0xFFFFB6C1), // Soft Pink
                Color(0xFFB5EAD7), // Mint Green
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Column(
            children: [
              Text(
                'One-Time Services',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '• Quick & Comprehensive Care',
                style: TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2-Column Grid for paired items
        if (gridItems.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.86,
            ),
            itemBuilder: (context, index) {
              return ServiceCardWidget(item: gridItems[index]);
            },
          ),

        // Odd trailing item rendered full-width (spans 2 columns)
        if (fullWidthItem != null) ...[
          if (gridItems.isNotEmpty) const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 110,
            child: ServiceCardWidget(
              item: fullWidthItem,
              isFullWidth: true,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> loadServices()async {
    ServicesResponse vehicle = await RestServiceImp.oneTimeServices();
    if(vehicle.isSuccess){
      read.setServices(vehicle.data);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}