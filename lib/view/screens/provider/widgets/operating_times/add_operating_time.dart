import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/api/graphql/mutations/operating_time/add_operating_time.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/time.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class AddOperatingTime extends StatelessWidget {
  AddOperatingTime({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            addOperatingTime}) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      addOperatingTime!({
        'day': '_day',
        'startTime': '_startTime',
        'endTime': '_endTime',
      });
    }

    return Mutation(
      options: MutationOptions(
        document: gql(
          AddOperatingTimeMutation().addOperatingTime,
        ),
        update: (
          GraphQLDataProxy? cache,
          QueryResult? result,
        ) {
          if (result!.hasException) {
            String errMessage = result.exception!.graphqlErrors[0].message;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AndroidAlertDialog(
                  title: 'Error',
                  message: Text(
                    errMessage,
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  popTimes: 2,
                );
              },
            );
          }
        },
        onCompleted: (dynamic addOperatingTimeResult) async {
          if (addOperatingTimeResult != null) {
            String message =
                addOperatingTimeResult['addOperatingTime']['message'];
            if (message.isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AndroidAlertDialog(
                    title: 'Completed',
                    message: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.lightGreen,
                      ),
                    ),
                    popTimes: 2,
                  );
                },
              );
            }
          }
        },
      ),
      builder: (
        RunMutation? runAddOperatingTimeMutation,
        QueryResult? addOperatingTimeResult,
      ) {
        if (addOperatingTimeResult!.isLoading) {
          return const AndroidLoading();
        }

        return Form(
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
                    // showSelectedItem: true,
                    items: Utils().weekDays(),
                    label: "Day",
                    hint: "Select day",
                    selectedItem: '_day',
                    onChanged: (String? input) {
                      // _day.value = input;
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Day is required';
                      }

                      return null;
                    },
                    dropdownSearchDecoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey),
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
                    selectedTime: '_startTime',
                    setTime: (time) {
                      // _startTime.value = DateFormat.Hm().format(time);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Time(
                    label: 'Select end time',
                    selectedTime:' _endTime',
                    setTime: (time) {
                      // _endTime.value = DateFormat.Hm().format(time);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AndroidButton(
                    label: 'Add',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit(addOperatingTime: runAddOperatingTimeMutation);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
