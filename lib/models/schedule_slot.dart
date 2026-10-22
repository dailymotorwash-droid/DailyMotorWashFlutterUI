class ScheduleSlot {
  final int slotInventoryId;
  final String label;
  final String startTime;
  final String startTimeLabel;
  final String endTime;
  final String endTimeLabel;
  final int available;
  final bool bookable;

  ScheduleSlot( {
    required this.slotInventoryId,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.available,
    required this.bookable,
    required this.startTimeLabel,
    required this.endTimeLabel,
  });

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) {
    return ScheduleSlot(
      slotInventoryId: json['slotInventoryId'] is int
          ? json['slotInventoryId']
          : int.tryParse('${json['slotInventoryId']}') ?? 0,
      label: json['label']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      startTimeLabel: json['startTimeLabel']?.toString() ?? '',
      endTimeLabel: json['endTimeLabel']?.toString() ?? '',
      available: json['available'] is int
          ? json['available']
          : int.tryParse('${json['available']}') ?? 0,
      bookable: json['bookable'] == true,
    );
  }
}

class DaySchedule {
  final String date;
  final String dayLabel;
  final Map<String, List<ScheduleSlot>> periods;

  DaySchedule({
    required this.date,
    required this.dayLabel,
    required this.periods,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    final Map<String, List<ScheduleSlot>> parsedPeriods = {
      'MORNING': [],
      'AFTERNOON': [],
      'EVENING': [],
    };

    if (json['periods'] is Map) {
      final rawMap = json['periods'] as Map;
      rawMap.forEach((key, val) {
        final normalizedKey = key.toString().toUpperCase().trim();
        if (val is List) {
          parsedPeriods[normalizedKey] = val
              .map((item) => ScheduleSlot.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
        }
      });
    }

    return DaySchedule(
      date: json['date'] ?? '',
      dayLabel: json['dayLabel'] ?? '',
      periods: parsedPeriods,
    );
  }
}