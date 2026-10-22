import 'package:dmw/ApiResponse/one_time_service_vehicle_response.dart';
import 'package:dmw/ApiResponse/services_response.dart';
import 'package:dmw/models/one_time_booking_vehicle.dart';
import 'package:dmw/models/service.dart';
import 'package:dmw/providers/one_time_service_vehicle_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Apis/RestServiceImp.dart';
import '../../providers/one_time_service_provider.dart';
import 'service_card_widget.dart';

class OneTimeBookingWidget extends StatefulWidget {
  const OneTimeBookingWidget({super.key});

  @override
  State<OneTimeBookingWidget> createState() => _OneTimeBookingState();
}

class _OneTimeBookingState extends State<OneTimeBookingWidget>
    with AutomaticKeepAliveClientMixin {
  late OneTimeServiceProvider read, watch;
  late OneTimeServiceVehicleProvider oneTimeSRead, oneTimeSWatch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read = context.read<OneTimeServiceProvider>();
    oneTimeSRead = context.read<OneTimeServiceVehicleProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadServices();
      loadOneTimeBookedVehicles();
    });
    // Future.microtask((){
    //   loadServices();
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final watch = context.watch<OneTimeServiceProvider>();
    final oneTimeSWatch = context.watch<OneTimeServiceVehicleProvider>();
// Determine if there is an odd item left at the end
    final bool hasOddLastItem = watch.services.length % 2 != 0;

    // Grid takes all even pairs (e.g., 4 items if length is 5; all 6 items if length is 6)
    final int gridItemCount =
        hasOddLastItem ? watch.services.length - 1 : watch.services.length;
    final List<Service> gridItems = watch.services.sublist(0, gridItemCount);

    // The leftover item to span full width (null if count is even)
    final Service? fullWidthItem = hasOddLastItem ? watch.services.last : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        oneTimeSWatch.vehicles.isNotEmpty
            ? ListView.builder(
          itemCount: oneTimeSWatch.vehicles.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = oneTimeSWatch.vehicles[index];
            return _buildOneTimeServiceVehicle(item);
          },
        )
            :
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

  Widget _buildOneTimeServiceVehicle(OneTimeBookingVehicle item) {
    final statusUpper = item.status.toUpperCase();
    final bool isCompleted = statusUpper == 'COMPLETED';
    final bool isCancelled = statusUpper == 'CANCELLED';

    final Color statusColor = isCompleted
        ? const Color(0xFF2E7D32)
        : isCancelled
        ? const Color(0xFFD32F2F)
        : const Color(0xFFE65100);

    final Color statusBg = isCompleted
        ? const Color(0xFFE8F5E9)
        : isCancelled
        ? const Color(0xFFFFEBEE)
        : const Color(0xFFFFF3E0);

    final String vehicleName = item.brand.isNotEmpty
        ? '${item.brand} ${item.model}'.trim()
        : (item.nickName.isNotEmpty ? item.nickName : 'Vehicle');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Vehicle Name + Reg Plate & Status Pill
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        vehicleName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (item.registrationNumber.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFCBD5E1), width: 0.8),
                        ),
                        child: Text(
                          item.registrationNumber.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Bottom Row: Date & Slot side-by-side with subtle icon
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 14,
                color: Color(0xFF757575),
              ),
              const SizedBox(width: 5),
              Text(
                _formatDate(item.bookingDate),
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                height: 10,
                width: 1,
                color: const Color(0xFFD0D0D0),
              ),
              Expanded(
                child: Text(
                  item.slotLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.tryParse(rawDate);
      if (dt != null) {
        return DateFormat('dd MMM yyyy').format(dt);
      }
    } catch (_) {}
    return rawDate;
  }


  Future<void> loadServices() async {
    ServicesResponse vehicle = await RestServiceImp.oneTimeServices();
    if (vehicle.isSuccess) {
      read.setServices(vehicle.data);
    }
  }

  Future<void> loadOneTimeBookedVehicles() async {
    OneTimeServiceVehicleResponse vehicle =
        await RestServiceImp.oneTimeServiceVehicles();
    if (vehicle.isSuccess) {
      oneTimeSRead.setVehicles(vehicle.data);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
