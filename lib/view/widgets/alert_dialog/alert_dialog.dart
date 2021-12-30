import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AndroidAlertDialog extends StatelessWidget {
  final String title;
  final Widget message;
  final bool replacePreviousNavigation;
  final String? navigateTo;
  final bool fromSignUp;
  final bool fromResendFirstOTP;
  final int? tabIndex;
  final int popTimes;

  const AndroidAlertDialog({
    required this.title,
    required this.message,
    this.navigateTo,
    this.replacePreviousNavigation = false,
    this.fromSignUp = false,
    this.fromResendFirstOTP = false,
    this.tabIndex,
    this.popTimes = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: message,
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            if (navigateTo != null) {
              if (replacePreviousNavigation) {
                if (fromSignUp) {
                  Get.toNamed(navigateTo!,
                      arguments: {'firstTimeSignin': true});
                } else {
                  Get.offAllNamed(navigateTo!);
                }
              } else {
                Get.toNamed(navigateTo!);
              }
            } else {
              for (int i = 0; i < popTimes; i++) {
                Get.back();
              }
            }
          },
        )
      ],
    );
  }
}
