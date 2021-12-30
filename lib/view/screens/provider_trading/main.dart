import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/provider_trading_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/provider_trading/provider_trading.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal/center_horizontal.dart';

class ProviderTradingScreen extends StatelessWidget {
  static final String routeName =
      '/${providerTradingTitle.toLowerCase().replaceAll(' ', '')}';

  ProviderTradingScreen({Key? key}) : super(key: key);

  final ProviderTradingController providerTradingController =
      Get.find<ProviderTradingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(
        title: providerTradingTitle,
      ),
      // drawer: AndroidDrawer(),
      body: Obx(
        () {
          return SafeArea(
            child: AndroidCenterHorizontal(
              screenContent: ProviderTrading(
                selectedIndex: providerTradingController.selectedIndex,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center_outlined),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'About',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.preview_outlined),
                label: 'Reviews',
              ),
            ],
            currentIndex: providerTradingController.selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            selectedIconTheme: const IconThemeData(size: 30.0),
            selectedLabelStyle:
                TextStyle(color: Theme.of(context).primaryColor),
            selectedFontSize: 16,
            unselectedItemColor: Colors.black26,
            onTap: (int index) {
              providerTradingController.selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}
