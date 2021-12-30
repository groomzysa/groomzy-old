import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/utils/enums.dart';

class Day {
  final int id;
  final BusinessDay day;
  final List<DayTime>? dayTimes;

  Day({
    required this.id,
    required this.day,
    this.dayTimes,
  });
}
