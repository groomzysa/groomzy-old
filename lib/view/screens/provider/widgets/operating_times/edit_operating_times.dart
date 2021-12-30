import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/operating_time/edit_operating_time.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/time.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';
import 'package:intl/intl.dart';

class EditOperatingTime extends StatelessWidget {
  final int dayTimeId;
  final String day;
  final String startTime;
  final String endTime;

  EditOperatingTime({
    required this.dayTimeId,
    required this.day,
    required this.startTime,
    required this.endTime,
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            editOperatingTime}) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      editOperatingTime!({
        'dayTimeId': dayTimeId,
        'day': '_day',
        'startTime': '_startTime',
        'endTime': '_endTime',
      });
    }

    return Mutation(
      options: MutationOptions(
        document: gql(
          EditOperatingTimeMutation().editOperatingTime,
        ),
        update: (
          GraphQLDataProxy? cache,
          QueryResult? result,
        ) {
          if (result!.hasException) {
            String errMessage = result.exception!.graphqlErrors[0].toString();
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
        onCompleted: (dynamic editOperatingTimeResult) async {
          if (editOperatingTimeResult != null) {
            String message =
                editOperatingTimeResult['editOperatingTime']['message'];
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
        RunMutation? runEditOperatingTimeMutation,
        QueryResult? editOperatingTimeResult,
      ) {
        if (editOperatingTimeResult!.isLoading) {
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
                  const AndroidTextField(
                    value: '_day',
                    label: 'Day',
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
                    selectedTime: '_startTime' ?? startTime,
                    setTime: (time) {
                      // _startTime.value = DateFormat.Hm().format(time);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  Time(
                    label: 'Select end time',
                    selectedTime: '_endTime' ?? endTime,
                    setTime: (time) {
                      // _endTime.value = DateFormat.Hm().format(time);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AndroidButton(
                    label: 'Edit',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit(editOperatingTime: runEditOperatingTimeMutation);
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
