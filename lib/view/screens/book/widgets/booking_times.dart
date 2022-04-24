import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/time.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:intl/intl.dart';

class BookingTimes extends StatelessWidget {
  final int minimumDuration;
  final int duration;
  final List<Booking> bookings;

  BookingTimes({
    required this.minimumDuration,
    required this.duration,
    required this.bookings,
    Key? key,
  }) : super(key: key);

  final BookController bookController = Get.find();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    List<DayTime> dayTimes = providerController.provider.dayTimes ?? [];
    List<List<Map>> times() {
      String day =
          DateFormat.yMEd().add_jms().format(bookController.selectedDay).split(',')[0];
      var selectedDayOperating = dayTimes.where((dayTime) {
        return Utils().mapDayToString(dayTime.day.day) == day;
      }).toList();

      Time selectedDayOperatingTime;

      if (selectedDayOperating.isEmpty) {
        return [];
      }

      selectedDayOperatingTime = selectedDayOperating[0].time;

      String startTime = selectedDayOperatingTime.startTime;
      String endTime = selectedDayOperatingTime.endTime;

      TimeOfDay startTimeOfDay = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]),
      );

      TimeOfDay endTimeOfDay = TimeOfDay(
        hour: int.parse(endTime.split(':')[0]),
        minute: int.parse(endTime.split(':')[1]),
      );

      List<TimeOfDay> _times = [];

      double end = endTimeOfDay.hour + (endTimeOfDay.minute / 60);
      double start = startTimeOfDay.hour + (startTimeOfDay.minute / 60);

      while (end >= start) {
        int hrz = (startTimeOfDay.minute + minimumDuration) ~/ 60;
        int min = (startTimeOfDay.minute + minimumDuration) % 60;
        bool isMinutesMore = startTimeOfDay.minute + min > 59;

        _times.add(
          startTimeOfDay,
        );

        startTimeOfDay = TimeOfDayExtension(startTimeOfDay).add(
          hour: isMinutesMore ? hrz + 1 : hrz,
          minute: isMinutesMore ? min - 60 : min,
        );

        start = startTimeOfDay.hour + (startTimeOfDay.minute / 60);
      }

      List bookedTimes = [];

      for (var time in _times) {
        bookings.where((booking) {
          String bookingDay =
          DateFormat.yMEd().add_jms().format(booking.bookingTime).split(',')[0];

          String bookingDate = DateFormat.yMd().format(bookController.selectedDay);
          String selectedDate = DateFormat.yMd().format(booking.bookingTime);

          return bookingDay == day && bookingDate == selectedDate;
        }).forEach((booking) {
          Service service = booking.service;
          bool isHours = service.durationUnit == 'hrz';
          double durationInMinutes = isHours
              ? double.parse(service.duration.toString()) * 60
              : double.parse(service.duration.toString());

          String strBookingTime =
              DateFormat().add_Hm().format(booking.bookingTime);
          TimeOfDay bookingTime = TimeOfDay(
            hour: int.parse(strBookingTime.split(':')[0]),
            minute: int.parse(strBookingTime.split(':')[1]),
          );
          TimeOfDay bookingDurationTime = TimeOfDay(
            hour: bookingTime.hour + (durationInMinutes / 60).floor(),
            minute: bookingTime.minute + (durationInMinutes % 60).floor(),
          );

          int minutesTime = time.hour * 60 + time.minute;
          int minutesBookingTime = bookingTime.hour * 60 + bookingTime.minute;
          int minutesBookingDurationTime =
              bookingDurationTime.hour * 60 + bookingDurationTime.minute;

          if (time == bookingTime) {
            bookedTimes.add(time);
          } else if ((minutesTime >= minutesBookingTime) &&
              (minutesTime < minutesBookingDurationTime)) {
            bookedTimes.add(time);
          } else if ((minutesTime <= minutesBookingTime) &&
              (minutesTime > (minutesBookingTime - duration))) {
            bookedTimes.add(time);
          }
        });
      }

      List<Map> mapTimes = _times.map((time) {
        if (bookedTimes.where((bookedTime) => bookedTime == time).isNotEmpty) {
          return {
            'occupied': true,
            'time': time,
          };
        }

        return {
          'occupied': false,
          'time': time,
        };
      }).toList();

      List<List<Map>> twoDList = [];
      int columnCount = -1;
      for (var i = 0; i < mapTimes.length; i++) {
        if (i % 4 == 0) {
          columnCount += 1;
          twoDList.add([mapTimes[i]]);
        } else {
          twoDList[columnCount].add(mapTimes[i]);
        }
      }

      return twoDList;
    }

    return Obx(() {
      return Container(
        constraints: const BoxConstraints(
          maxHeight: 200.0,
        ),
        padding: const EdgeInsets.only(bottom: 5.0),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                if (times().isEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: const Text(
                      'No available time slots on this day.\n\nPlease choose a different day.',
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ...times().map((columns) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...columns.map((time) {
                        TimeOfDay _time = time['time'];
                        bool occupied = time['occupied'];
                        return GestureDetector(
                          onTap: () {
                            if (!occupied) {
                              if (bookController.selectedTime ==
                                  '${_time.hour}:${_time.minute}') {
                                bookController.selectedTime = 'none';
                                bookController.selectedStaffer = 'none';
                              } else {
                                bookController.selectedTime = '${_time.hour}:${_time.minute}';
                                bookController.selectedStaffer = 'none';
                              }
                            }
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 50, //minimum height
                              minWidth: 90, // minimum width
                            ),
                            child: Card(
                              elevation: bookController.selectedTime ==
                                  '${_time.hour}:${_time.minute}' &&
                                  !occupied
                                  ? 4
                                  : 0,
                              shadowColor: bookController.selectedTime ==
                                  '${_time.hour}:${_time.minute}' &&
                                  !occupied
                                  ? Theme.of(context).primaryColor
                                  : null,
                              color: occupied
                                  ? Colors.grey.shade300
                                  : bookController.selectedTime ==
                                  '${_time.hour}:${_time.minute}'
                                  ? null
                                  : null,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${_time.hour}:${_time.minute}',
                                  style: TextStyle(
                                    color: bookController.selectedTime ==
                                        '${_time.hour}:${_time.minute}' &&
                                        !occupied
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    fontWeight: bookController.selectedTime ==
                                        '${_time.hour}:${_time.minute}' &&
                                        !occupied
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}
