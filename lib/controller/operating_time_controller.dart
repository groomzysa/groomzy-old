import 'package:get/get.dart';

class OperatingTimeController extends GetxController {
  final Rx<int> _id = 0.obs;
  final Rx<String> _day = ''.obs;
  final Rx<String> _startTime = ''.obs;
  final Rx<String> _endTime = ''.obs;
  final Rx<bool> _isLoading = false.obs;

  int get id => _id.value;
  set id(int input) => _id.value = input;

  String get day => _day.value;
  set day(String input) => _day.value = input;

  String get startTime => _startTime.value;
  set startTime(String input) => _startTime.value = input;

  String get endTime => _endTime.value;
  set endTime(String input) => _endTime.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;
}
