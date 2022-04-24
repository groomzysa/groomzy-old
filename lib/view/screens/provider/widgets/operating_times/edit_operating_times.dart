import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/provider/operating_time/edit_operating_time_mutation.dart';
import 'package:groomzy/controller/operating_time_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/time.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';
import 'package:intl/intl.dart';

class EditOperatingTime extends StatelessWidget {
  EditOperatingTime({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();
  final OperatingTimeController operatingTimeController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      try {
        Map<String, dynamic> response =
            await EditOperatingTimeMutation().editOperatingTimeMutation();
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
      if (operatingTimeController.isLoading) {
        return const AndroidLoading();
      }
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                        FontAwesomeIcons.times,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  AndroidTextField(
                    label: 'Day',
                    value: operatingTimeController.day,
                    enabled: false,
                  ),
                  const SizedBox(height: 10.0),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('NB! Can only update the times.'),
                  ),
                  const SizedBox(height: 10.0),
                  Time(
                    label: 'Select start time',
                    selectedTime: operatingTimeController.startTime,
                    setTime: (time) {
                      operatingTimeController.startTime =
                          DateFormat.Hm().format(time);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Time(
                    label: 'Select end time',
                    selectedTime: operatingTimeController.endTime,
                    setTime: (time) {
                      operatingTimeController.endTime =
                          DateFormat.Hm().format(time);
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
