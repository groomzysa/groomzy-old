import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/calender/calender.dart';
import 'package:intl/intl.dart';

class BookingCalendar extends StatelessWidget {
  BookingCalendar({
    Key? key
  }) : super(key: key);

  final BookController bookController = Get.find();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    List<DayTime> dayTimes = providerController.provider.dayTimes!;

    return Obx(() {
      return AndroidCalendar(
        dateNow: bookController.dateNow,
        calendarFormat: bookController.calendarFormat,
        selectedDay: bookController.selectedDay,
        onDaySelected: (DateTime? _selectedDay, focusedDa) {
          if (_selectedDay != null) {
            String day =
                DateFormat.yMEd().add_jms().format(_selectedDay).split(',')[0];
            List activeDays = dayTimes
                .where(
                    (dayTime) => Utils().mapDayToString(dayTime.day.day) == day)
                .toList();

            if (activeDays.isEmpty) {
              bookController.selectedTime = 'none';
            }
            bookController.selectedDay = _selectedDay;
            bookController.selectedTime = 'none';
            bookController.selectedStaffer = 'none';
            bookController.serviceCallAddress = 'none';
          }
        },
        onFormatChanged: (format) {
          if (bookController.calendarFormat != format) {
            // Call `setState()` when updating calendar format
            bookController.calendarFormat = format;
          }
        },
      );
    });
  }
}
