import 'package:flutter/material.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/about/about.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';

class AboutScreen extends StatelessWidget {
  static final String routeName = '/${aboutTitle.toLowerCase()}';

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(title: aboutTitle,),
      drawer: AndroidDrawer(),
      body: const SafeArea(
        child: AndroidCenterHorizontalVertical(screenContent: About(),),
      ),
    );
  }
}
