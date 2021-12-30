import 'package:groomzy/model/day.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/time.dart';

class DayTime {
  final int id;
  final Day day;
  final Time time;
  final Provider? provider;

  DayTime({
    required this.id,
    this.provider,
    required this.day,
    required this.time,
  });
}
