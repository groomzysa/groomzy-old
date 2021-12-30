import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/controller/explore_controller.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/about/main.dart';
import 'package:groomzy/view/screens/book/main.dart';
import 'package:groomzy/view/screens/checkout/main.dart';
import 'package:groomzy/view/screens/client/main.dart';
import 'package:groomzy/view/screens/contacts/main.dart';
import 'package:groomzy/view/screens/explorer/main.dart';
import 'package:groomzy/view/screens/provider/main.dart';
import 'package:groomzy/view/screens/provider_trading/main.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/screens/signup/main.dart';
import 'package:groomzy/view/screens/ts_and_cs/main.dart';

import 'config/client.dart';

Future main() async {
  await dotenv.load();
  await initHiveForFlutter();
  await GetStorage.init();

  Get.put(GlobalsController());
  Get.put(ExploreController());
  Get.put(ProviderController());
  Get.put(ClientController());

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var globalsController = Get.find<GlobalsController>();

    return GraphQLProvider(
      client: APIClient().getAPIClient(),
      child: Obx(() {
        var user = globalsController.user;
        return GetMaterialApp(
          title: appTitle,
          initialRoute: Utils().navigateToHome(user['role'] ?? ''),
          getPages: [
            GetPage(name: ExploreScreen.routeName, page: () => ExploreScreen()),
            GetPage(name: SignInScreen.routeName, page: () => SignInScreen()),
            GetPage(name: SignUpScreen.routeName, page: () => SignUpScreen()),
            GetPage(
                name: AboutScreen.routeName, page: () => const AboutScreen()),
            GetPage(
                name: ContactScreen.routeName,
                page: () => const ContactScreen()),
            GetPage(
                name: ProviderTradingScreen.routeName,
                page: () => ProviderTradingScreen()),
            GetPage(name: BookScreen.routeName, page: () => BookScreen()),
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
