// ---------------------------------------------------------
// PROVIDER (State Management)
// ---------------------------------------------------------
import 'package:flutter/cupertino.dart';

class ScheduleProvider extends ChangeNotifier {
  int _selectedDateIndex = -1;
  int _selectedDurationIndex = -1;
  int _selectedPeriodIndex = 0; // 0: Morning
  int _selectedSlotIndex = -1;

  late final List<String> dateLabels;
  late final List<DateTime> dateObjects;

  final List<Map<String, String>> durations = [
    {'duration': '60 min', 'price': '₹0', 'mrp': '₹278'},
    {'duration': '90 min', 'price': '₹70', 'mrp': '₹417'},
    {'duration': '2 hrs', 'price': '₹130', 'mrp': '₹557'},
    {'duration': '2.5 hrs', 'price': '₹190', 'mrp': '₹697'},
  ];

  final List<String> periods = ['Morning', 'Afternoon', 'Evening'];

  final List<String> morningSlots = [
    '7:00 AM', '7:15 AM', '7:30 AM', '7:45 AM',
    '8:00 AM', '8:15 AM', '8:30 AM', '8:45 AM',
    '9:00 AM', '9:15 AM', '9:30 AM', '9:45 AM',
  ];

  ScheduleProvider() {
    _initDynamicDates();
  }

  // Getters
  int get selectedDateIndex => _selectedDateIndex;
  int get selectedDurationIndex => _selectedDurationIndex;
  int get selectedPeriodIndex => _selectedPeriodIndex;
  int get selectedSlotIndex => _selectedSlotIndex;

  bool get isDateSelected => _selectedDateIndex != -1;
  bool get isDurationSelected => _selectedDurationIndex != -1;
  bool get isSlotSelected => _selectedSlotIndex != -1;
  bool get isReadyToContinue => isDateSelected && isSlotSelected;
  void _initDynamicDates() {
    const weekdayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    final now = DateTime.now();
    dateObjects = [
      DateTime(now.year, now.month, now.day),
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      DateTime(now.year, now.month, now.day).add(const Duration(days: 2)),
    ];

    final thirdDayName = weekdayNames[dateObjects[2].weekday - 1];
    dateLabels = ['Today', 'Tomorrow', thirdDayName];
  }

  void selectDate(int index) {
    if (_selectedDateIndex != index) {
      _selectedDateIndex = index;
      _selectedDurationIndex = -1; // Reset child selections
      _selectedSlotIndex = -1;
      notifyListeners();
    }
  }

  void selectDuration(int index) {
    if (_selectedDurationIndex != index) {
      _selectedDurationIndex = index;
      _selectedSlotIndex = -1; // Reset slot selection
      notifyListeners();
    }
  }

  void selectPeriod(int index) {
    _selectedPeriodIndex = index;
    notifyListeners();
  }

  void selectSlot(int index) {
    _selectedSlotIndex = index;
    notifyListeners();
  }

  // Combines date and slot into a single DateTime object
  DateTime? get selectedDateTime {
    if (!isDateSelected || !isSlotSelected) return null;

    final baseDate = dateObjects[_selectedDateIndex];
    final slotString = morningSlots[_selectedSlotIndex];

    final parts = slotString.split(' ');
    final timeComponents = parts[0].split(':');
    int hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);
    final isPM = parts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  String get formattedSchedule {
    final dt = selectedDateTime;
    if (dt == null) return '';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    final weekday = weekdays[dt.weekday - 1];
    final month = months[dt.month - 1];
    final time = morningSlots[_selectedSlotIndex];

    return '$weekday, ${dt.day} $month ${dt.year} at $time';
  }
}