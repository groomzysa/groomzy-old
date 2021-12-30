import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AndroidCalendar extends StatelessWidget {
  final DateTime dateNow;
  final CalendarFormat calendarFormat;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat x) onFormatChanged;

  const AndroidCalendar({
    required this.dateNow,
    required this.calendarFormat,
    this.selectedDay,
    required this.onDaySelected,
    required this.onFormatChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: dateNow,
      lastDay: dateNow.add(const Duration(days: 10 * 365)),
      focusedDay: dateNow,
      rowHeight: 40.0,
      calendarFormat: calendarFormat,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(selectedDay, day);
      },
      onDaySelected: onDaySelected,
      onFormatChanged: onFormatChanged,
      calendarStyle: CalendarStyle(
        // Use `CalendarStyle` to customize the UI
        isTodayHighlighted: false,
        selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 2.5)),
        selectedTextStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
