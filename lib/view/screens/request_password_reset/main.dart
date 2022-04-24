import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/request_password_reset_controller.dart';

import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/request_password_reset/request_password_reset.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';

class RequestPasswordResetScreen extends StatelessWidget {
  static final String routeName =
      '/${requestPasswordResetTitle.toLowerCase().replaceAll(' ', '')}';

  const RequestPasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RequestPasswordResetController());

    return Scaffold(
      appBar: AndroidAppBar(
        title: requestPasswordResetTitle,
      ),
      body: SafeArea(
        child: AndroidCenterHorizontalVertical(
          screenContent: RequestPasswordReset(),
        ),
      ),
    );
  }
}
