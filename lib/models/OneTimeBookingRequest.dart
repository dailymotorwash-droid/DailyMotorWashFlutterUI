

class OneTimeBookingRequest {
  final String vehicleId; // UUID as String
  final int serviceId;
  final int rateId;
  final double rate;
  final double discount;
  final String bookingDate; // Maps to LocalDate (yyyy-MM-dd)
  final String paymentId;
  final int slotInventoryId;
  final String addressId;
  final String? cancelReason;
  final String slotStartTime; // Maps to LocalTime (HH:mm:ss)
  final String slotEndTime;   // Maps to LocalTime (HH:mm:ss)
  final String slotLabel;
  // e.g. "7 AM - 8 AM"

  OneTimeBookingRequest(  {
    required this.vehicleId,
    required this.serviceId,
    required this.rateId,
    required this.rate,
    required this.discount,
    required this.bookingDate,
    required this.slotStartTime,
    required this.slotEndTime,
    required this.slotLabel,
    required this.paymentId,
    required this.slotInventoryId, required this.addressId,this.cancelReason,
  });

  /// Formats human-readable times ("7:00 AM" or "7 AM") into 24-hr ISO LocalTime ("07:00:00")
  // static String formatToLocalTime(String timeStr) {
  //   try {
  //     final clean = timeStr.trim().toUpperCase();
  //     DateTime dt;
  //     if (clean.contains(':')) {
  //       dt = DateFormat('h:mm a').parse(clean);
  //     } else {
  //       dt = DateFormat('h a').parse(clean);
  //     }
  //     return DateFormat('HH:mm:ss').format(dt);
  //   } catch (_) {
  //     // Return as-is if parsing fails or if already formatted
  //     return timeStr;
  //   }
  // }

  /// Parses slot label like "7 AM - 8 AM" into start and end LocalTime
  // static Map<String, String> parseSlotTimes(String slotLabel, String fallbackStartTime) {
  //   try {
  //     final parts = slotLabel.split('-');
  //     if (parts.length == 2) {
  //       return {
  //         'start': formatToLocalTime(parts[0].trim()),
  //         'end': formatToLocalTime(parts[1].trim()),
  //       };
  //     }
  //   } catch (_) {}
  //
  //   return {
  //     'start': formatToLocalTime(fallbackStartTime),
  //     'end': formatToLocalTime(fallbackStartTime),
  //   };
  // }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'serviceId': serviceId,
      'rateId': rateId,
      'rate': rate,
      'discount': discount,
      // LocalDate: yyyy-MM-dd
      'bookingDate': bookingDate,
      // LocalTime: HH:mm:ss
      'slotStartTime': slotStartTime,
      'slotEndTime': slotEndTime,
      'slotLabel': slotLabel,
      'razorPayId': paymentId,
      'slotInventoryId': slotInventoryId,
      'addressId': addressId,
      'cancelReason': cancelReason,

    };
  }
}