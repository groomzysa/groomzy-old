import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/staff/add_staff.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class AddStaff extends StatelessWidget {
  AddStaff({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            addStaff}) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      addStaff!({
        'fullName': '_fullName.value',
      });
    }

    return Mutation(
      options: MutationOptions(
        document: gql(
          AddStaffMutation().addStaff,
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
        onCompleted: (dynamic addStaffResult) async {
          if (addStaffResult != null) {
            String message = addStaffResult['addStaff']['message'];
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
        RunMutation? runAddStaffMutation,
        QueryResult? addStaffResult,
      ) {
        if (addStaffResult!.isLoading) {
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
                  AndroidTextField(
                    value: '_fullName.value',
                    label: 'Full name',
                    onInputChange: (String input) {
                      // _fullName.value = input;
                    },
                    onValidation: (String? input) {
                      if (input == null || input.isEmpty) {
                        return 'Full name is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AndroidButton(
                    label: 'Add',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit(addStaff: runAddStaffMutation);
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
