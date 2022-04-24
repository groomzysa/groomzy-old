import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/operating_time_controller.dart';
import 'package:intl/intl.dart';

import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/api/graphql/mutations/provider/operating_time/add_operating_time_mutation.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/time.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class AddOperatingTime extends StatelessWidget {
  AddOperatingTime({Key? key}) : super(key: key);

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
            await AddOperatingTimeMutation().addOperatingTimeMutation();
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
                popTimes: 1,
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

    List<String> unSelectedWeekDays(){
      List<String> activeWeekDays = Utils().weekDays;
      for(var dT in providerController.operatingTimes) {
        activeWeekDays.remove(Utils().mapDayToString(dT.day.day));
      }

      return activeWeekDays;
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
                  const SizedBox(height: 10.0),
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    items: unSelectedWeekDays(),
                    selectedItem: operatingTimeController.day.isEmpty ? null : operatingTimeController.day,
                    onChanged: (String? input) {
                      operatingTimeController.day = input ?? '';
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Day is required';
                      }

                      return null;
                    },
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Day",
                      hintText: "Select day",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.view_day_outlined, color: Colors.grey,),
                      contentPadding:
                          EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
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
                    label: 'Add',
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
