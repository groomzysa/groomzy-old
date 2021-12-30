import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/service/delete_service.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class DeleteService extends StatelessWidget {
  final int serviceId;
  final String category;

  const DeleteService({
    required this.serviceId,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            deleteService}) async {
      deleteService!({
        'serviceId': serviceId,
        'category': category,
      });
    }

    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Are you sure want to delete service?'),
      actions: <Widget>[
        Mutation(
          options: MutationOptions(
            document: gql(
              DeleteServiceMutation().deleteService,
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
            onCompleted: (dynamic deleteServiceResult) async {
              if (deleteServiceResult != null) {
                String message =
                    deleteServiceResult['deleteService']['message'];
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
            RunMutation? runDeleteServiceMutation,
            QueryResult? deleteServiceResult,
          ) {
            if (deleteServiceResult!.isLoading) {
              return const AndroidLoading();
            }

            return TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                _submit(deleteService: runDeleteServiceMutation);
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
