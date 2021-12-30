import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/signup_controller.dart';

import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/signup/signup.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';


class SignUpScreen extends StatelessWidget {
  static final String routeName = '/${signupTitle.toLowerCase()}';

  SignUpScreen({Key? key}) : super(key: key);

  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(title: signupTitle,),
      drawer: AndroidDrawer(),
      body: SafeArea(
        child: AndroidCenterHorizontalVertical(screenContent: SignUp(),),
      ),
    );
  }
}
