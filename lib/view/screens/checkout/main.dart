import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/checkout_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/checkout/checkout.dart';

class CheckoutScreen extends StatelessWidget {
  static final String routeName =
      '/${checkoutTitle.toLowerCase().replaceAll(' ', '')}';

  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CheckoutController());

    return Checkout();
  }
}
