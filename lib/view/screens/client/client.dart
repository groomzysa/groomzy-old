import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/view/screens/client/widgets/bookings.dart';
import 'package:groomzy/view/screens/explorer/explorer.dart';
import 'package:groomzy/view/widgets/center_horizontal/center_horizontal_expanded.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical_expanded.dart';

class Client extends StatelessWidget {
  Client({
    Key? key,
  }) : super(key: key);
  final ClientController clientController = Get.find();

  List<Widget> _widgetOptions() {
    return <Widget>[
      AndroidCenterHorizontalVerticalExpanded(screenContent: Explore()),
      AndroidCenterHorizontalExpanded(screenContent: Bookings()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: _widgetOptions().elementAt(clientController.selectedIndex),
      ),
    );
  }
}
