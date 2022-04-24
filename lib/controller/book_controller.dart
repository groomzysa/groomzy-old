import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class BookController extends GetxController{
  final Rx<int> _id = 0.obs;
  final Rx<CalendarFormat> _calendarFormat = CalendarFormat.twoWeeks.obs;
  final Rx<DateTime> _dateNow = DateTime.now().obs;
  final Rx<DateTime> _selectedDay = DateTime.now().obs;
  final Rx<String> _selectedTime = 'none'.obs;
  final Rx<String> _selectedStaffer = 'none'.obs;
  final Rx<int> _selectedStafferId = 0.obs;
  final Rx<String> _serviceCallAddress = 'none'.obs;
  final Rx<bool> _inHouse = false.obs;
  final Rx<bool> _complete = false.obs;
  final Rx<bool> _done = false.obs;
  final Rx<bool> _cancel = false.obs;
  final Rx<bool> _delete = false.obs;
  final Rx<bool> _rate = false.obs;
  final Rx<bool> _isLoading = false.obs;
  final Rx<int> _ratingId = 0.obs;
  final Rx<double> _rating = 0.0.obs;
  final Rx<String> _comment = ''.obs;

  int get id => _id.value;
  set id(int input) => _id.value = input;

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

  bool get complete => _complete.value;
  set complete(bool input) => _complete.value = input;

  bool get done => _done.value;
  set done(bool input) => _done.value = input;

  bool get cancel => _cancel.value;
  set cancel(bool input) => _cancel.value = input;

  bool get delete => _delete.value;
  set delete(bool input) => _delete.value = input;

  bool get rate => _rate.value;
  set rate(bool input) => _rate.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;

  int get ratingId => _ratingId.value;
  set ratingId(int input) => _ratingId.value = input;

  double get rating => _rating.value;
  set rating(double input) => _rating.value = input;

  String get comment => _comment.value;
  set comment(String input) => _comment.value = input;
}