import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/client/booking_complete_mutation.dart';
import 'package:groomzy/api/graphql/mutations/client/booking_delete_mutation.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/checkout_controller.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/controller/provider_trading_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../client/main.dart';
import '../../widgets/loading/loading.dart';

class Checkout extends StatefulWidget {
  Checkout({Key? key}) : super(key: key);

  final CheckoutController checkoutController = Get.find();
  final BookController bookController = Get.find();
  final ProviderTradingController providerTradingController = Get.find();
  final ClientController clientController = Get.find();

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    const bool isProduction = kReleaseMode;
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

    final String name = widget.providerTradingController.selectedService.title;
    final String description =
        widget.providerTradingController.selectedService.description;
    final double price = widget.providerTradingController.selectedService.price;

    final String url = Uri.encodeFull(
      '$payFastUrl?merchant_id=$payFastMerchantId&merchant_key=$payFastMerchantKey&item_name=$name&item_description=$description&amount=$price&return_url=$successUrl&cancel_url=$cancelUrl',
    );

    Future<void> _submit(bool status) async {
      try {
        Map<String, dynamic> response;

        if(status) {
          widget.bookController.complete = true;
          response =  await ClientBookingCompleteMutation().clientBookingCompleteMutation();
          if (response['status']!) {
            widget.bookController.id = 0;
            widget.bookController.selectedDay = DateTime.now();
            widget.bookController.selectedStafferId = 0;
            widget.bookController.selectedStaffer = 'none';
            widget.bookController.inHouse = false;
            widget.bookController.selectedTime = 'none';
            widget.bookController.serviceCallAddress = 'none';
            widget.bookController.complete = false;

            widget.clientController.selectedIndex = 1;
            Get.defaultDialog(
              title: 'Info',
              content: Text(
                response['message'],
              ),
              radius: 0,
              actions: [
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  onPressed: () => Get.offNamedUntil(ClientScreen.routeName, (Route<dynamic> r) => false),
                )
              ],
            );
          }
        } else {
          widget.bookController.delete = true;
          response = await ClientBookingDeleteMutation().clientBookingDeleteMutation();
          if (response['status']!) {
            widget.bookController.id = 0;
            widget.bookController.selectedDay = DateTime.now();
            widget.bookController.selectedStafferId = 0;
            widget.bookController.selectedStaffer = 'none';
            widget.bookController.inHouse = false;
            widget.bookController.selectedTime = 'none';
            widget.bookController.serviceCallAddress = 'none';
            widget.bookController.delete = false;

            widget.clientController.selectedIndex = 0;
            Get.defaultDialog(
              title: 'Info',
              content: const Text(
                'Booking canceled',
              ),
              radius: 0,
              actions: [
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  onPressed: () => Get.back(closeOverlays: true),
                )
              ],
            );
          }
        }
      } catch (err) {
        Get.defaultDialog(
          title: 'Oops!',
          content: Text(
            '$err',
          ),
          radius: 0,
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () => Get.back(closeOverlays: true),
            )
          ],
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Make payment'),
      ),
      body: Obx(
        () {
          return Stack(
            children: <Widget>[
              WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) {
                  if (request.url == cancelUrl) {
                    _submit(false);
                  } else if (request.url == successUrl) {
                    _submit(true);
                  }

                  return NavigationDecision.navigate;
                },
                gestureNavigationEnabled: true,
                onPageFinished: (finish) {
                  widget.checkoutController.isLoading = false;
                },
              ),
              widget.checkoutController.isLoading
                  ? const Center(
                      child: AndroidLoading(),
                    )
                  : Stack(),
            ],
          );
        },
      ),
    );
  }
}
