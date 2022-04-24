import 'package:flutter/material.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/ts_and_cs/ts_and_cs.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';


class TsAndCsScreen extends StatelessWidget {
  static final String routeName = '/${tsAndCsTitle.toLowerCase().replaceAll(' ', '_')}';

  const TsAndCsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(title: tsAndCsTitle,),
      drawer: Utils().currentDevice(context)['isDesktop']! ? null : AndroidDrawer(),
      body: const SafeArea(
        child: TsAndCs(),
      ),
    );
  }
}
