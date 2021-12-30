import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/summary_service_provider_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/explorer/explorer.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical_expanded.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';


class ExploreScreen extends StatelessWidget {
  static final String routeName = '/${exploreTitle.toLowerCase()}';

  ExploreScreen({Key? key}) : super(key: key);

  final ProviderController providerController = Get.put(ProviderController());
  final SummaryServiceProviderController summaryServiceProviderController =
      Get.put(SummaryServiceProviderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(
        title: homeTitle,
      ),
      drawer: AndroidDrawer(),
      body: SafeArea(
        child: AndroidCenterHorizontalVerticalExpanded(
          screenContent: Explore(),
        ),
      ),
    );
  }
}
