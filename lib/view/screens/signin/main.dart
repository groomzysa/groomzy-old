import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/signin_controller.dart';

import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/signin/signin.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';


class SignInScreen extends StatelessWidget {
  static final String routeName = '/${signInTitle.toLowerCase()}';

  SignInScreen({Key? key}) : super(key: key);

  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(title: signInTitle,),
      drawer: AndroidDrawer(),
      body: SafeArea(
        child: AndroidCenterHorizontalVertical(screenContent: SignIn(),),
      ),
    );
  }
}
