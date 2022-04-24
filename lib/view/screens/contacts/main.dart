import 'package:flutter/material.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';

import './contacts.dart';

class ContactScreen extends StatelessWidget {
  static final String routeName = '/${contactTitle.toLowerCase()}';

  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(title: contactTitle,),
      drawer: Utils().currentDevice(context)['isDesktop']! ? null : AndroidDrawer(),
      body: const SafeArea(
        child: AndroidCenterHorizontalVertical(screenContent: Contact(),),
      ),
    );
  }
}
