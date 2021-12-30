import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookController extends GetxController{
  final Rx<CalendarFormat> _calendarFormat = CalendarFormat.twoWeeks.obs;
  final Rx<DateTime> _dateNow = DateTime.now().obs;
  final Rx<DateTime> _selectedDay = DateTime.now().obs;
  final Rx<String> _selectedTime = 'none'.obs;
  final Rx<String> _selectedStaffer = 'none'.obs;
  final Rx<int> _selectedStafferId = 0.obs;
  final Rx<String> _serviceCallAddress = 'none'.obs;
  final Rx<bool> _inHouse = false.obs;

  CalendarFormat get calendarFormat => _calendarFormat.value;
  set calendarFormat(CalendarFormat input) => _calendarFormat.value = input;

  DateTime get dateNow => _dateNow.value;
  set dateNow(DateTime input) => _dateNow.value = input;

  DateTime get selectedDay => _selectedDay.value;
  set selectedDay(DateTime input) => _selectedDay.value = input;

  String get selectedTime => _selectedTime.value;
  set selectedTime(String input) => _selectedTime.value = input;

  String get selectedStaffer => _selectedStaffer.value;
  set selectedStaffer(String input) => _selectedStaffer.value = input;

  int get selectedStafferId => _selectedStafferId.value;
  set selectedStafferId(int input) => _selectedStafferId.value = input;

  String get serviceCallAddress => _serviceCallAddress.value;
  set serviceCallAddress(String input) => _serviceCallAddress.value = input;

  bool get inHouse => _inHouse.value;
  set inHouse(bool input) => _inHouse.value = input;
}