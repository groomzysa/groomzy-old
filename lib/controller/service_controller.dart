import 'package:get/get.dart';

class ServiceController extends GetxController {
  final Rx<int> _id = 0.obs;
  final Rx<String> _category = ''.obs;
  final Rx<String> _description = ''.obs;
  final Rx<double> _duration = 0.0.obs;
  final Rx<String> _durationUnit = ''.obs;
  final Rx<bool> _inHouse = false.obs;
  final Rx<double> _price = 0.0.obs;
  final Rx<String> _title = ''.obs;
  final Rx<bool> _isLoading = false.obs;

  int get id => _id.value;
  set id(int input) => _id.value = input;

  String get description => _category.value;
  set description(String input) => _category.value = input;

  String get category => _description.value;
  set category(String input) => _description.value = input;

  double get duration => _duration.value;
  set duration(double input) => _duration.value = input;

  String get durationUnit => _durationUnit.value;
  set durationUnit(String input) => _durationUnit.value = input;

  bool get inHouse => _inHouse.value;
  set inHouse(bool input) => _inHouse.value = input;

  double get price => _price.value;
  set price(double input) => _price.value = input;

  String get title => _title.value;
  set title(String input) => _title.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;
}
