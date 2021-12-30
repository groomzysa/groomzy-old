import 'package:flutter/material.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/time.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:intl/intl.dart';

class BookingTimes extends StatelessWidget {
  final Function selectTime;
  final List<DayTime> dayTimes;
  final DateTime selectedDay;
  final String? selectedTime;
  final int minimumDuration;
  final int duration;
  final List<Booking> bookings;

  const BookingTimes({
    required this.dayTimes,
    required this.selectTime,
    required this.selectedDay,
    this.selectedTime,
    required this.minimumDuration,
    required this.duration,
    required this.bookings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<Map>> times() {
      String day = DateFormat.yMEd().add_jms().format(selectedDay).split(',')[0];
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
          minute:isMinutesMore ? min - 60 : min,
        );

        start = startTimeOfDay.hour + (startTimeOfDay.minute / 60);
      }

      List bookedTimes = [];

      for (var time in _times) {
        bookings.where((booking) {
          return booking.bookingTime!.difference(selectedDay).inDays == 0;
        }).forEach((booking) {

          Service service = booking.service!;
          bool isHours = service.durationUnit == 'hrz';
          double durationInMinutes = isHours
              ? double.parse(service.duration.toString()) * 60
              : double.parse(service.duration.toString());

          String strBookingTime = DateFormat().add_Hm().format(booking.bookingTime!);
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

    return Container(
      height: 130.0,
      padding: const EdgeInsets.only(bottom: 5.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            if (times().isEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: const Text(
                  'No available time slots, please choose a different day.',
                  style: TextStyle(
                    fontSize: 18.0,
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
                          print({'selectedTime': selectedTime});
                          if (selectedTime == '${_time.hour}:${_time.minute}') {
                            selectTime('none');
                          } else {
                            selectTime('${_time.hour}:${_time.minute}');
                          }
                        }
                      },
                      child: SizedBox(
                        height: 50.0,
                        width: 95,
                        child: Card(
                          elevation:
                              selectedTime == '${_time.hour}:${_time.minute}' &&
                                      !occupied
                                  ? 4
                                  : 0,
                          shadowColor:
                              selectedTime == '${_time.hour}:${_time.minute}' &&
                                      !occupied
                                  ? Theme.of(context).primaryColor
                                  : null,
                          color: occupied
                              ? Colors.grey.shade300
                              : selectedTime == '${_time.hour}:${_time.minute}'
                                  ? null
                                  : null,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${_time.hour}:${_time.minute}',
                              style: TextStyle(
                                color: selectedTime ==
                                            '${_time.hour}:${_time.minute}' &&
                                        !occupied
                                    ? Theme.of(context).primaryColor
                                    : null,
                                fontWeight: selectedTime ==
                                            '${_time.hour}:${_time.minute}' &&
                                        !occupied
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                fontSize: selectedTime ==
                                            '${_time.hour}:${_time.minute}' &&
                                        !occupied
                                    ? 18.0
                                    : 16,
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
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: this.hour + hour, minute: this.minute + minute);
  }
}
