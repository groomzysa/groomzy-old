import 'package:get/get.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/model/user.dart';

class GlobalsController extends GetxController{
  final RxMap _user = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  Map get user => _user.value;
  set user(Map input) => _user.value = input;

  getUser() {
    Map loggedInUser = APIUtils().getUser();
    user = loggedInUser;
  }
}