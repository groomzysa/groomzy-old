import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/about/main.dart';
import 'package:groomzy/view/screens/book/main.dart';
import 'package:groomzy/view/screens/checkout/main.dart';
import 'package:groomzy/view/screens/client/main.dart';
import 'package:groomzy/view/screens/contacts/main.dart';
import 'package:groomzy/view/screens/edit_profile/main.dart';
import 'package:groomzy/view/screens/explorer/main.dart';
import 'package:groomzy/view/screens/provider/main.dart';
import 'package:groomzy/view/screens/provider_trading/main.dart';
import 'package:groomzy/view/screens/request_password_reset/main.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/screens/signup/main.dart';
import 'package:groomzy/view/screens/ts_and_cs/main.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/controller/explore_controller.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';

import 'config/client.dart';

class MainMobileApp extends StatelessWidget {
  MainMobileApp({Key? key}) : super(key: key);

  final globalsController = Get.put(GlobalsController());
  final exploreController = Get.put(ExploreController());
  final providerController = Get.put(ProviderController());
  final clientController = Get.put(ClientController());

  @override
  Widget build(BuildContext context) {
    var globalsController = Get.find<GlobalsController>();

    return GraphQLProvider(
      client: APIClient().getAPIClient(),
      child: Obx(() {
        var user = globalsController.user;
        return GetMaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          title: appTitle,
          initialRoute: Utils().navigateToHome(user['role'] ?? ''),
          getPages: [
            GetPage(name: ExploreScreen.routeName, page: () => const ExploreScreen()),
            GetPage(name: SignInScreen.routeName, page: () => const SignInScreen()),
            GetPage(name: SignUpScreen.routeName, page: () => const SignUpScreen()),
            GetPage(name: EditProfileScreen.routeName, page: () => const EditProfileScreen()),
            GetPage(
                name: RequestPasswordResetScreen.routeName,
                page: () => const RequestPasswordResetScreen()),
            GetPage(
                name: AboutScreen.routeName, page: () => const AboutScreen()),
            GetPage(
                name: ContactScreen.routeName,
                page: () => const ContactScreen()),
            GetPage(
                name: ProviderTradingScreen.routeName,
                page: () => ProviderTradingScreen()),
            GetPage(name: BookScreen.routeName, page: () => const BookScreen()),
            GetPage(
                name: CheckoutScreen.routeName,
                page: () => const CheckoutScreen()),
            GetPage(
                name: ProviderScreen.routeName, page: () => ProviderScreen()),
            GetPage(name: ClientScreen.routeName, page: () => ClientScreen()),
            GetPage(
                name: TsAndCsScreen.routeName,
                page: () => const TsAndCsScreen()),
          ],
          theme: ThemeData(
            primaryColor: Colors.blueGrey,
          ),
        );
      }),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}