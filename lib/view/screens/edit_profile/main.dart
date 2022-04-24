import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/EditProfileController.dart';

import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/edit_profile/edit_profile.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';

class EditProfileScreen extends StatelessWidget {
  static final String routeName =
      '/${editProfileTitle.toLowerCase().replaceAll(' ', '')}';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditProfileController());

    return Scaffold(
      appBar: AndroidAppBar(
        title: editProfileTitle,
      ),
      drawer: Utils().currentDevice(context)['isDesktop']! ? null : AndroidDrawer(),
      body: SafeArea(
        child: AndroidCenterHorizontalVertical(
          screenContent: EditProfile(),
        ),
      ),
    );
  }
}
