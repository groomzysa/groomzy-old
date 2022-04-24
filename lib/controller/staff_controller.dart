import 'package:get/get.dart';

class StaffController extends GetxController {
  final Rx<int> _id = 0.obs;
  final Rx<String> _fullName = ''.obs;
  final Rx<bool> _isLoading = false.obs;

  int get id => _id.value;
  set id(int input) => _id.value = input;

  String get fullName => _fullName.value;
  set fullName(String input) => _fullName.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;
}
