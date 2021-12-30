import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/staff/edit_staff.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class EditStaff extends StatelessWidget {
  final int staffId;
  final String fullName;

  EditStaff({
    required this.staffId,
    required this.fullName,
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            editStaff}) async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();

      editStaff!({
        'staffId': staffId,
        'fullName': '_fullName.value',
      });
    }

    return Mutation(
      options: MutationOptions(
        document: gql(EditStaffMutation().editStaff),
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
        onCompleted: (dynamic editStaffResult) async {
          if (editStaffResult != null) {
            String message = editStaffResult['editStaff']['message'];
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
        RunMutation? runEditStaffMutation,
        QueryResult? editStaffResult,
      ) {
        if (editStaffResult!.isLoading) {
          return const AndroidLoading();
        }
        return Form(
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
                    value: '_fullName.value' ?? fullName,
                    label: 'title',
                    onInputChange: (String input) {
                      // _fullName.value = input;
                    },
                  ),
                  AndroidButton(
                    label: 'Edit',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit(editStaff: runEditStaffMutation);
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
