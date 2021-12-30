import 'package:get/get.dart';

class ClientController extends GetxController{
  final Rx<int> _selectedIndex = 0.obs;
  final Rx<int> _clientId = 0.obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int input) => _selectedIndex.value = input;

  int get clientId => _clientId.value;
  set clientId(int input) => _clientId.value = input;
}