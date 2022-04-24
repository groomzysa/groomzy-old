import 'package:get/get.dart';

class EditProfileController extends GetxController{
  final Rx<int> _id = 0.obs;
  final Rx<String> _fullName = ''.obs;
  final Rx<String> _email = ''.obs;
  final Rx<String> _password = ''.obs;
  final Rx<String> _phoneNumber = ''.obs;
  final Rx<bool> _isProvider = false.obs;
  final Rx<bool> _isLoading = false.obs;
  final Rx<bool> _showPassword = false.obs;
  final Rx<String> _streetNumber = ''.obs;
  final Rx<String> _streetName = ''.obs;
  final Rx<String> _suburbName = ''.obs;
  final Rx<String> _cityName = ''.obs;
  final Rx<String> _provinceName = ''.obs;
  final Rx<String> _areaCode = ''.obs;
  final Rx<double> _latitude = 0.0.obs;
  final Rx<double> _longitude = 0.0.obs;

  int get id => _id.value;
  set id(int input) => _id.value = input;

  String get fullName => _fullName.value;
  set fullName(String input) => _fullName.value = input;

  String get email => _email.value;
  set email(String input) => _email.value = input;

  String get password => _password.value;
  set password(String input) => _password.value = input;

  String get phoneNumber => _phoneNumber.value;
  set phoneNumber(String input) => _phoneNumber.value = input;

  bool get isProvider => _isProvider.value;
  set isProvider(bool input) => _isProvider.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;

  bool get showPassword => _showPassword.value;
  set showPassword(bool input) => _showPassword.value = input;

  String get streetNumber => _streetNumber.value;
  set streetNumber(String input) => _streetNumber.value = input;

  String get streetName => _streetName.value;
  set streetName(String input) => _streetName.value = input;

  String get suburbName => _suburbName.value;
  set suburbName(String input) => _suburbName.value = input;

  String get cityName => _cityName.value;
  set cityName(String input) => _cityName.value = input;

  String get provinceName => _provinceName.value;
  set provinceName(String input) => _provinceName.value = input;

  String get areaCode => _areaCode.value;
  set areaCode(String input) => _areaCode.value = input;

  double get latitude => _latitude.value;
  set latitude(double input) => _latitude.value = input;

  double get longitude => _longitude.value;
  set longitude(double input) => _longitude.value = input;
}