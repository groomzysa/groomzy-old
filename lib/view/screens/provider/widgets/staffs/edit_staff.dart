import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/provider/staff/edit_staff_mutation.dart';
import 'package:groomzy/controller/staff_controller.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class EditStaff extends StatelessWidget {
  EditStaff({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StaffController staffController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();

      try {
        Map<String, dynamic> response =
            await EditStaffMutation().editStaffMutation();
        if (response['status']!) {
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
              popTimes: 2,
            );
          },
        );
      }
    }

    return Obx(() {
      if (staffController.isLoading) {
        return const AndroidLoading();
      }
      return SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 500.0,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 10.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  AndroidTextField(
                    value: staffController.fullName,
                    label: 'Full name',
                    onInputChange: (String input) {
                      staffController.fullName = input;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AndroidButton(
                    label: 'Edit',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
