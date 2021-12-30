import 'package:groomzy/model/day_time.dart';

class Time {
  final int id;
  final String startTime;
  final String endTime;
  final List<DayTime>? dayTimes;

  Time({
    required this.id,
    required this.endTime,
    required this.startTime,
    this.dayTimes,
  });
}
