import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final Rx<int> _progress = 0.obs;
  final Rx<bool> _isLoading = true.obs;

  int get progress => _progress.value;
  set progress(int input) => _progress.value = input;

  bool get isLoading => _isLoading.value;
  set isLoading(bool input) => _isLoading.value = input;
}
