import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:groomzy/main_mobile_app.dart';
import 'package:groomzy/main_web_app.dart';

Future main() async {
  await dotenv.load();
  await initHiveForFlutter();
  await GetStorage.init();
  setPathUrlStrategy();

  runApp(kIsWeb ? MainWebApp() : MainMobileApp());
}
