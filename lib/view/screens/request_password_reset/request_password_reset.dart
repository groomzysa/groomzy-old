import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:groomzy/api/graphql/mutations/client/client_signin_mutation.dart';
import 'package:groomzy/api/graphql/mutations/provider/provider_signin_mutation.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/request_password_reset_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/client/main.dart';
import 'package:groomzy/view/screens/provider/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class RequestPasswordReset extends StatelessWidget {
  RequestPasswordReset({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RequestPasswordResetController requestPasswordResetController = Get.find();
  final GlobalsController globalsController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
            {Object? optimisticResult})?
        signIn}) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      signIn!({
        'email': requestPasswordResetController.email.trim(),
      });
    }

    return Obx(
          () => SingleChildScrollView(
        child: Mutation(
          options: MutationOptions(
            document: gql(
              requestPasswordResetController.isProvider
                  ? SignInProviderMutation().signinProvider
                  : SignInClientMutation().signinClient,
            ),
            update: (
                GraphQLDataProxy? cache,
                QueryResult? result,
                ) {
              if (result!.hasException) {
                String errMessage =
                    result.exception?.graphqlErrors[0].message ??
                        'Something intimate is wrong';
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AndroidAlertDialog(
                      title: 'Oops!',
                      message: Text(
                        errMessage,
                      ),
                    );
                  },
                );
              }
            },
            onCompleted: (dynamic signInResult) async {
              if (signInResult != null) {
                Map signedIn = signInResult[requestPasswordResetController.isProvider
                    ? 'signinProvider'
                    : 'signinClient'];
                String token = signedIn['token'];
                if (token.isNotEmpty) {
                  Map user = {
                    'id': signedIn['id'],
                    'email': signedIn['email'],
                    'fullName': signedIn['fullName'],
                    'phoneNumber': signedIn['phoneNumber'],
                    'role': signedIn['role'],
                  };
                  APIUtils().setToken(token);
                  APIUtils().setUser(jsonEncode(user));
                  globalsController.user = user;
                  requestPasswordResetController.email = '';
                  requestPasswordResetController.isProvider = false;

                  Navigator.of(context).pushReplacementNamed(
                    requestPasswordResetController.isProvider
                        ? ProviderScreen.routeName
                        : ClientScreen.routeName,
                  );
                }
              }
            },
          ),
          builder: (
              RunMutation? runSignInMutation,
              QueryResult? signInResult,
              ) {
            if (signInResult!.isLoading) {
              return const AndroidLoading();
            }
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      logoImage,
                      fit: BoxFit.cover,
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  AndroidTextField(
                      value: requestPasswordResetController.email.trim(),
                      label: 'Email',
                      prefixIcon: Icons.email_outlined,
                      onInputChange: (input) {
                        requestPasswordResetController.email = input;
                      },
                      onValidation: (String? input) {
                        if (input == null || input.isEmpty) {
                          return 'Email is required';
                        }
                        if (!EmailValidator.validate(input.trim())) {
                          return 'Invalid email';
                        }

                        return null;
                      }),
                  const SizedBox(height: 10.0),
                  AndroidCheckBox(
                    label: 'Are you a service provider?',
                    checked: requestPasswordResetController.isProvider,
                    onChecked: (checked) {
                      requestPasswordResetController.isProvider = checked!;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AndroidButton(
                    label: 'Request password reset',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () async {
                      _submit(signIn: runSignInMutation);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
