import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:groomzy/api/graphql/mutations/provider/operating_time/delete_operating_time_mutation.dart';
import 'package:groomzy/controller/operating_time_controller.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class DeleteOperatingTime extends StatelessWidget {
  DeleteOperatingTime({Key? key}) : super(key: key);

  final OperatingTimeController operatingTimeController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      try {
        Map<String, dynamic> response =
            await DeleteOperatingTimeMutation().deleteOperatingTimeMutation();
        if (response['status']!) {
          Get.back();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AndroidAlertDialog(
                title: 'Info',
                message: Text(
                  response['message'],
                ),
                popTimes: 2,
              );
            },
          );
        }
      } catch (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AndroidAlertDialog(
              title: 'Oops!',
              message: Text(
                '$err',
              ),
            );
          },
        );
      }
    }

    return AlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure want to delete business time?'),
      actions: <Widget>[
        Obx(() {
          if (operatingTimeController.isLoading) {
            return const AndroidLoading();
          }
          return TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              _submit();
            },
          );
        }),
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.amber),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}
