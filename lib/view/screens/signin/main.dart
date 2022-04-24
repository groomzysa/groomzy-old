import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/signin_controller.dart';

import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/signin/signin.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';


class SignInScreen extends StatelessWidget {
  static final String routeName = '/${signInTitle.toLowerCase()}';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignInController());

    return Scaffold(
      appBar: AndroidAppBar(title: signInTitle,),
      drawer: Utils().currentDevice(context)['isDesktop']! ? null : AndroidDrawer(),
      body: SafeArea(
        child: AndroidCenterHorizontalVertical(screenContent: SignIn(),),
      ),
    );
  }
}
