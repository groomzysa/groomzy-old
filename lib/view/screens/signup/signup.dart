import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:groomzy/api/graphql/mutations/client/signup.dart';
import 'package:groomzy/api/graphql/mutations/provider/provider_signup.dart';
import 'package:groomzy/controller/signup_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignupController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            signUp}) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      signUp!({
        'email': signupController.email.trim(),
        'fullName': signupController.fullName.trim(),
        'password': signupController.password.trim(),
        'phoneNumber': signupController.phoneNumber.trim(),
      });
    }

    return Mutation(
      options: MutationOptions(
        document: gql(
          signupController.isProvider
              ? SignUpProviderMutation().signupProvider
              : SignUpClientMutation().signupClient,
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
                );
              },
            );
          }
        },
        onCompleted: (dynamic signUpResult) async {
          if (signUpResult != null) {
            String message = signUpResult[signupController.isProvider
                ? 'signupProvider'
                : 'signupClient']['message'];
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
                    navigateTo: SignInScreen.routeName,
                    replacePreviousNavigation: true,
                    fromSignUp: true,
                  );
                },
              );
            }
          }
        },
      ),
      builder: (
        RunMutation? runSignUpMutation,
        QueryResult? signUpResult,
      ) {
        if (signUpResult!.isLoading) {
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
                value: signupController.fullName.trim(),
                label: 'Full name',
                prefixIcon: Icons.person_outlined,
                onInputChange: (input) {
                  signupController.fullName = input;
                },
                onValidation: (String? input) {
                  if (input == null || input.isEmpty) {
                    return 'First name is required';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              AndroidTextField(
                  value: signupController.email.trim(),
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  onInputChange: (input) {
                    signupController.email = input;
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
                  value: signupController.phoneNumber.trim(),
                  label: 'Phone number',
                  prefixIcon: Icons.phone_android_outlined,
                  onInputChange: (input) {
                    signupController.phoneNumber = input;
                  },
                  onValidation: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Phone number is required';
                    }

                    return null;
                  }),
              const SizedBox(height: 10.0),
              AndroidTextField(
                  value: signupController.password.trim(),
                  label: 'Password',
                  obscureText: true,
                  prefixIcon: Icons.password_outlined,
                  onInputChange: (input) {
                    signupController.password = input;
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
                checked: signupController.isProvider,
                onChecked: (checked) {
                  signupController.isProvider = checked!;
                },
              ),
              AndroidButton(
                label: 'Sign up',
                backgroundColor: Theme.of(context).primaryColor,
                pressed: () async {
                  _submit(signUp: runSignUpMutation);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
