import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/calender/calender.dart';
import 'package:intl/intl.dart';

class BookingCalendar extends StatelessWidget {
  final List<DayTime> dayTimes;

  BookingCalendar({
    required this.dayTimes,
    Key? key,
  }) : super(key: key);

  final BookController bookController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookController>(builder: (c) {
      return AndroidCalendar(
        dateNow: c.dateNow,
        calendarFormat: c.calendarFormat,
        selectedDay: c.selectedDay,
        onDaySelected: (DateTime? _selectedDay, focusedDa) {
          if (_selectedDay != null) {
            String day =
                DateFormat.yMEd().add_jms().format(_selectedDay).split(',')[0];
            List activeDays = dayTimes
                .where(
                    (dayTime) => Utils().mapDayToString(dayTime.day.day) == day)
                .toList();

            if (activeDays.isEmpty) {
              c.selectedTime = 'none';
            }
            c.selectedDay = _selectedDay;
          }
        },
        onFormatChanged: (format) {
          if (c.calendarFormat != format) {
            // Call `setState()` when updating calendar format
            c.calendarFormat = format;
          }
        },
      );
    });
  }
}
