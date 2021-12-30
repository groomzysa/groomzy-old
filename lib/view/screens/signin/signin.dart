import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:groomzy/api/graphql/mutations/client/signin.dart';
import 'package:groomzy/api/graphql/mutations/provider/provider_signin.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/signin_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/client/main.dart';
import 'package:groomzy/view/screens/provider/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInController signInController = Get.find();
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
        'email': signInController.email.trim(),
        'password': signInController.password.trim(),
      });
    }

    return Obx(
      () => SingleChildScrollView(
        child: Mutation(
          options: MutationOptions(
            document: gql(
              signInController.isProvider
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
                      title: 'Error',
                      message: Text(
                        errMessage,
                        style: const TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  },
                );
              }
            },
            onCompleted: (dynamic signInResult) async {
              if (signInResult != null) {
                Map signedIn = signInResult[signInController.isProvider
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
                  signInController.email = '';
                  signInController.password = '';
                  signInController.isProvider = false;

                  Navigator.of(context).pushReplacementNamed(
                    signInController.isProvider
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
                      value: signInController.email.trim(),
                      label: 'Email',
                      prefixIcon: Icons.email_outlined,
                      onInputChange: (input) {
                        signInController.email = input;
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
                  AndroidTextField(
                      value: signInController.password.trim(),
                      label: 'Password',
                      obscureText: true,
                      prefixIcon: Icons.password_outlined,
                      onInputChange: (input) {
                        signInController.password = input;
                      },
                      onValidation: (String? input) {
                        if (input == null || input.isEmpty) {
                          return 'Password is required';
                        }
                        if (input.length < 5) {
                          return 'Password should be at least 5 characters.';
                        }

                        return null;
                      }),
                  const SizedBox(height: 10.0),
                  AndroidCheckBox(
                    label: 'Signing up as a service provider?',
                    checked: signInController.isProvider,
                    onChecked: (checked) {
                      signInController.isProvider = checked!;
                    },
                  ),
                  AndroidButton(
                    label: 'Sign in',
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
