import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/screens/provider/widgets/bookings/bookings.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/operating_times.dart';
import 'package:groomzy/view/screens/provider/widgets/services/services.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/staffs.dart';
import 'package:groomzy/view/widgets/center_horizontal/center_horizontal_expanded.dart';

class Provider extends StatelessWidget {
  Provider({Key? key}) : super(key: key);

  final ProviderController providerController = Get.find();

  List<Widget> _widgetOptions() {
    return <Widget>[
      AndroidCenterHorizontalExpanded(
        screenContent: Services(),
      ),
      AndroidCenterHorizontalExpanded(
        screenContent: Bookings(),
      ),
      AndroidCenterHorizontalExpanded(
        screenContent: Staffs(),
      ),
      AndroidCenterHorizontalExpanded(
          screenContent: OperatingTimes()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      child: _widgetOptions().elementAt(providerController.selectedIndex),
    ));
  }
}
