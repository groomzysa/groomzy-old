import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:groomzy/api/graphql/mutations/operating_time/delete_operating_time.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class DeleteOperatingTime extends StatelessWidget {
  final int dayTimeId;

  const DeleteOperatingTime({
    required this.dayTimeId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            deleteOperatingTime}) async {
      deleteOperatingTime!({
        'dayTimeId': dayTimeId,
      });
    }

    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Are you sure want to delete business time?'),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            document: gql(
              DeleteOperatingTimeMutation().deleteOperatingTime,
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
            onCompleted: (dynamic deleteOperatingTimeResult) async {
              if (deleteOperatingTimeResult != null) {
                String message =
                    deleteOperatingTimeResult['deleteOperatingTime']['message'];
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
            RunMutation? runDeleteOperatingTimeMutation,
            QueryResult? deleteOperatingTimeResult,
          ) {
            if (deleteOperatingTimeResult!.isLoading) {
              return const AndroidLoading();
            }

            return TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                _submit(deleteOperatingTime: runDeleteOperatingTimeMutation);
              },
            );
          },
        ),
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
