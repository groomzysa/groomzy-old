import 'package:get/get.dart';

class RequestPasswordResetController extends GetxController{
  final Rx<String> _email = ''.obs;
  final Rx<bool> _isProvider = false.obs;

  String get email => _email.value;
  set email(String input) => _email.value = input;

  bool get isProvider => _isProvider.value;
  set isProvider(bool input) => _isProvider.value = input;
}