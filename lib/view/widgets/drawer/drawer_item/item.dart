import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/utils/enums.dart';

class AndroidDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? navigateTo;
  final NavigatorNamedType? navigateType;

  AndroidDrawerItem({
    required this.icon,
    required this.title,
    this.navigateTo,
    this.navigateType,
    Key? key,
  }) : super(key: key);

  final GlobalsController globalsController = Get.find();

  @override
  Widget build(BuildContext context) {
    void tapAction() {
      if (navigateTo != null) {
        if (title == 'Sign out') {
          GetStorage().remove('token');
          GetStorage().remove('user');
          globalsController.user = {};
          Get.offAllNamed(navigateTo!);
        } else {
          switch (navigateType) {
            case NavigatorNamedType.popAndPush:
              Get.toNamed(navigateTo!);
              break;
            case NavigatorNamedType.pushAndReplace:
              Get.offAllNamed(navigateTo!);
              break;
            default:
              Get.toNamed(navigateTo!);
          }
        }
      }
    }

    return GestureDetector(
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
      ),
      onTap: () {
        tapAction();
      },
    );
  }
}
