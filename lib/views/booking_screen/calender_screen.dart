import 'package:flutter/material.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({ Key? key }) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PagedVerticalCalendar(
          minDate: DateTime.now().subtract(Duration(days: 365)),
          maxDate: DateTime.now().add(Duration(days: 365)),
          initialDate: DateTime.now(),
          // monthBuilder: (context, month, year) {
          //   return 
          // },
        ),
      ),
    );
  }
}