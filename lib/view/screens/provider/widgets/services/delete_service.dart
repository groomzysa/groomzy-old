import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/provider/service/delete_service_mutation.dart';
import 'package:groomzy/controller/service_controller.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class DeleteService extends StatelessWidget {
  DeleteService({Key? key}) : super(key: key);

  final ServiceController serviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      try {
        Map<String, dynamic> response =
            await DeleteServiceMutation().deleteServiceMutation();
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
      content: const Text('Are you sure want to delete service?'),
      actions: <Widget>[
        Obx(() {
          if (serviceController.isLoading) {
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
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
