// ---------------------------------------------------------
// PROVIDER (State Management)
// ---------------------------------------------------------
import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../ApiResponse/slot_response.dart';
import '../models/schedule_slot.dart';

class ScheduleProvider extends ChangeNotifier {
  int _selectedDateIndex = -1;
  int _selectedDurationIndex = -1;
  int _selectedPeriodIndex = 0; // 0: Morning
  int _selectedSlotIndex = -1;
  int _selectedDayIndex = 0;
  String? _errorMessage;
  bool _isLoading = false;
  String? get selectedDateString => selectedDay?.date;
  List<DaySchedule> _days = [];
  late final List<String> dateLabels;
  late final List<DateTime> dateObjects;
  ScheduleSlot? _selectedSlot;
  List<DaySchedule> get days => _days;
  final List<String> periodKeys = ['MORNING', 'AFTERNOON', 'EVENING'];
  final List<String> periods = ['Morning', 'Afternoon', 'Evening'];

  ScheduleProvider() {
    _initDynamicDates();
  }

  // Getters
  bool get isLoading => _isLoading;
  int get selectedDateIndex => _selectedDateIndex;
  int get selectedDurationIndex => _selectedDurationIndex;
  int get selectedPeriodIndex => _selectedPeriodIndex;
  int get selectedSlotIndex => _selectedSlotIndex;

  bool get isDateSelected => _selectedDateIndex != -1;
  bool get isDurationSelected => _selectedDurationIndex != -1;
  bool get isSlotSelected => _selectedSlotIndex != -1;
  bool get isReadyToContinue => _selectedSlot != null;
  ScheduleSlot? get selectedSlot => _selectedSlot;
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


  // Current selected day's entity
  DaySchedule? get selectedDay =>
      (_days.isNotEmpty && _selectedDateIndex < _days.length)
          ? _days[_selectedDateIndex]
          : null;

  // Active slots for the current selected Day + Period
  List<ScheduleSlot> get currentSlots {
    final day = selectedDay;
    if (day == null) return [];
    final key = periodKeys[_selectedPeriodIndex];
    return day.periods[key] ?? [];
  }

// --- API Action ---
  Future<void> fetchSlots(int addressId) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedSlot = null;
    notifyListeners();

    try {
      // Call your static method
      final SlotResponse response = await RestServiceImp.slots(addressId);

      _days = response.data;
      if (_days.isNotEmpty) {
        // 1. Locate the index of "Today", fallback to 0 if not labeled
        final todayIndex = _days.indexWhere(
              (day) => day.dayLabel.toLowerCase() == 'today',
        );
        _selectedDayIndex = todayIndex != -1 ? todayIndex : 0;

        // 2. Auto-select the first period that actually has slots
        _selectedPeriodIndex = _findFirstActivePeriodIndex(_selectedDayIndex);
      }
      _selectedSlot = null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _days = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // --- Helper to default to an active period ---
  int _findFirstActivePeriodIndex(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= _days.length) return 0;

    final day = _days[dayIndex];
    for (int i = 0; i < periodKeys.length; i++) {
      final slots = day.periods[periodKeys[i]];
      if (slots != null && slots.isNotEmpty) {
        return i; // First period with available slots
      }
    }
    return 0; // Default to MORNING if all periods are empty
  }

  // --- User Selection Actions ---
  void selectDay(int index) {
    if (_selectedDayIndex == index) return;
    _selectedDayIndex = index;
    // When switching days, automatically switch to the period containing slots
    _selectedPeriodIndex = _findFirstActivePeriodIndex(index);
    _selectedSlot = null;
    notifyListeners();
  }
  void selectPeriod(int index) {
    if (_selectedPeriodIndex == index) return;
    _selectedPeriodIndex = index;
    _selectedSlot = null; // Clear selected slot when period tab switches
    notifyListeners();
  }
  void selectSlot(ScheduleSlot slot) {
    if (!slot.bookable || slot.available <= 0) return;
    _selectedSlot = slot;
    notifyListeners();
  }
  void clearSelection() {
    _selectedSlot = null;
    notifyListeners();
  }
  void selectDate(int index) {
    if (_selectedDateIndex != index) {
      _selectedDateIndex = index;
      // 1. Reset the selected slot back to unselected
      _selectedSlot = null;
      _selectedDurationIndex = -1;
      // 2. Optionally reset period to the first available period or Morning (0)
      _selectedPeriodIndex = _findFirstActivePeriodIndex(index);// Reset child selections
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
  //
  // void selectPeriod(int index) {
  //   _selectedPeriodIndex = index;
  //   notifyListeners();
  // }
  //
  // void selectSlot(int index) {
  //   _selectedSlotIndex = index;
  //   notifyListeners();
  // }

  // Combines date and slot into a single DateTime object
  // DateTime? get selectedDateTime {
  //   if (!isDateSelected || !isSlotSelected) return null;
  //
  //   final baseDate = dateObjects[_selectedDateIndex];
  //   final slotString = morningSlots[_selectedSlotIndex];
  //
  //   final parts = slotString.split(' ');
  //   final timeComponents = parts[0].split(':');
  //   int hour = int.parse(timeComponents[0]);
  //   final minute = int.parse(timeComponents[1]);
  //   final isPM = parts[1].toUpperCase() == 'PM';
  //
  //   if (isPM && hour != 12) hour += 12;
  //   if (!isPM && hour == 12) hour = 0;
  //
  //   return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  // }

// Formatted display string (e.g. "Tomorrow, 8:00 AM - 9:00 AM")
  String get formattedSchedule {
    if (_days.isEmpty || _selectedSlot == null) {
      return 'No slot selected';
    }
    final day = selectedDay;
    final dayText = day?.dayLabel ?? '';
    return '$dayText, ${_selectedSlot!.label}';
  }

  // Parse chosen Date and Slot Start Time into a single DateTime
  DateTime? get selectedDateTime {
    if (selectedDay == null || _selectedSlot == null) return null;
    try {
      final datePart = selectedDay!.date; // e.g. "2026-10-18"
      final timePart = _selectedSlot!.startTime.trim(); // e.g. "7:00 AM"

      // Parse string components
      final parsedDate = DateTime.parse(datePart);
      final parsedTime = DateFormat('h:mm a').parse(timePart);

      return DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (_) {
      return DateTime.tryParse(selectedDay!.date);
    }
  }

  /// Clears existing data, selections, and error states
  void resetSchedule() {
    _days = [];
    _selectedDateIndex = 0;
    _selectedPeriodIndex = 0;
    _selectedSlot = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

}