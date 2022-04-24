import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/summary_service_provider_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/client/client.dart';
import 'package:groomzy/view/screens/explorer/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';

class ClientScreen extends StatelessWidget {
  static final String routeName = '/${clientTitle.toLowerCase()}';

  ClientScreen({Key? key}) : super(key: key);

  final SummaryServiceProviderController summaryServiceProviderController =
      Get.put(SummaryServiceProviderController());
  final GlobalsController globalsController = Get.find();
  final ClientController clientController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (globalsController.user.isEmpty) {
      return AndroidAlertDialog(
        title: 'Info',
        message: const Text(
          'It appears you are no longer signed in, please sign in.',
        ),
        navigateTo: ExploreScreen.routeName,
        replacePreviousNavigation: true,
      );
    } else {
      clientController.clientId = int.parse(
        globalsController.user['id'].toString(),
      );
      return Obx(() {
        return Scaffold(
          appBar: AndroidAppBar(
            title:
                clientController.selectedIndex == 1 ? 'Bookings' : 'Providers',
          ),
          drawer: Utils().currentDevice(context)['isDesktop']! ? null : AndroidDrawer(),
          body: SafeArea(child: Client()),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center_outlined),
                label: 'Providers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'Bookings',
              ),
            ],
            currentIndex: clientController.selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            selectedIconTheme: const IconThemeData(size: 30.0),
            selectedLabelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            selectedFontSize: 16,
            unselectedItemColor: Colors.black26,
            onTap: (int index) {
              clientController.selectedIndex = index;
            },
          ),
        );
      });
    }
  }
}
