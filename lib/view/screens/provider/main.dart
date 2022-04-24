import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/provider/provider.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';

class ProviderScreen extends StatelessWidget {
  static final String routeName = '/${providerTitle.toLowerCase()}';

  ProviderScreen({Key? key}) : super(key: key);

  final GlobalsController globalsController = Get.find();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      providerController.selectedIndex = index;
    }

    return Scaffold(
      appBar: AndroidAppBar(
        title: providerTitle,
      ),
      drawer: Utils().currentDevice(context)['isDesktop']! ? null : AndroidDrawer(),
      body: SafeArea(
        child: Provider(),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.business_center_outlined),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'Staffs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timelapse_outlined),
              label: 'Time',
            ),
          ],
          currentIndex: providerController.selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          selectedIconTheme: const IconThemeData(size: 30.0),
          selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
          selectedFontSize: 18,
          unselectedItemColor: Colors.black26,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
