import 'package:get/get.dart';

class SignInController extends GetxController{
  final Rx<String> _email = ''.obs;
  final Rx<String> _password = ''.obs;
  final Rx<bool> _isProvider = false.obs;
  final Rx<bool> _isLoading = false.obs;
  final Rx<bool> _showPassword = false.obs;

  String get email => _email.value;
  set email(String input) => _email.value = input;

  String get password => _password.value;
  set password(String input) => _password.value = input;

  bool get isProvider => _isProvider.value;
  set isProvider(bool input) => _isProvider.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;

  bool get showPassword => _showPassword.value;
  set showPassword(bool input) => _showPassword.value = input;
}