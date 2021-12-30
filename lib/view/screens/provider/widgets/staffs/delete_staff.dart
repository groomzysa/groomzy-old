import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/staff/delete_staff.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class DeleteStaff extends StatelessWidget {
  final int staffId;

  const DeleteStaff({required this.staffId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            deleteStaff}) async {
      deleteStaff!({
        'staffId': staffId,
      });
    }

    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Are you sure want to delete staff?'),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            document: gql(
              DeleteStaffMutation().deleteStaff,
            ),
            update: (
              GraphQLDataProxy? cache,
              QueryResult? result,
            ) {
              if (result!.hasException) {
                String errMessage =
                    result.exception!.graphqlErrors[0].toString();
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
            onCompleted: (dynamic deleteStaffResult) async {
              if (deleteStaffResult != null) {
                String message = deleteStaffResult['deleteStaff']['message'];
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
            RunMutation? runDeleteStaffMutation,
            QueryResult? deleteStaffResult,
          ) {
            if (deleteStaffResult!.isLoading) {
              return const AndroidLoading();
            }

            return TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                _submit(deleteStaff: runDeleteStaffMutation);
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
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
