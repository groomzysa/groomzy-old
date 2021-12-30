import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../client/main.dart';
import '../../widgets/loading/loading.dart';

class Checkout extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final int bookingId;
  final MultiSourceResult Function(Map<String, dynamic>,
      {Object? optimisticResult})? clientBookCompleteMutation;

  const Checkout({
    required this.bookingId,
    this.clientBookCompleteMutation,
    required this.description,
    required this.name,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _webViewController = FlutterWebviewPlugin();

    final bool isProduction = kReleaseMode;
    final String? payFastUrl = isProduction
        ? dotenv.env['PAYFAST_SANDBOX']
        : dotenv.env['PAYFAST_SANDBOX'];
    final String? payFastMerchantId = isProduction
        ? dotenv.env['MERCHANT_ID_SANDBOX']
        : dotenv.env['MERCHANT_ID_SANDBOX'];
    final String? payFastMerchantKey = isProduction
        ? dotenv.env['MERCHANT_KEY_SANDBOX']
        : dotenv.env['MERCHANT_KEY_SANDBOX'];
    final String? successUrl = dotenv.env['SUCCESS_URL'];
    final String? cancelUrl = dotenv.env['CANCEL_URL'];

    final String url = Uri.encodeFull(
        '$payFastUrl?merchant_id=$payFastMerchantId&merchant_key=$payFastMerchantKey&item_name=$name&item_description=$description&amount=$price&return_url=$successUrl&cancel_url=$cancelUrl');
    Future<void> _submit(bool status) async {
      try {
        clientBookCompleteMutation!({
          'bookingId': bookingId,
          'complete': status,
        });
      } catch (error) {
        return;
      }
    }

    _webViewController.onUrlChanged.listen((String url) async {
      if (url == cancelUrl) {
        await _submit(false);
        _webViewController.close();
        Get.back();
      }

      if (url == successUrl) {
        await _submit(true);
        _webViewController.close();
        Get.offNamed(ClientScreen.routeName);
      }
    });

    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Make payment'),
      ),
      initialChild: const AndroidLoading(),
      withJavascript: true,
    );
  }
}
