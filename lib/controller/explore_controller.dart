import 'package:get/get.dart';

class ExploreController extends GetxController{
  final Rx<String> _search = ''.obs;
  final Rx<String> _category = ''.obs;


  String get search => _search.value;
  set search(String input) => _search.value = input;

  String get category => _category.value;
  set category(String input) => _category.value = input;
}