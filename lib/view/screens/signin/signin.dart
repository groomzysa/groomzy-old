import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';

import 'package:groomzy/api/graphql/mutations/client/client_signin_mutation.dart';
import 'package:groomzy/api/graphql/mutations/provider/provider_signin_mutation.dart';
import 'package:groomzy/controller/signin_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/client/main.dart';
import 'package:groomzy/view/screens/provider/main.dart';
import 'package:groomzy/view/screens/request_password_reset/main.dart';
import 'package:groomzy/view/screens/signup/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInController signInController = Get.find();

  @override
  Widget build(BuildContext context) {
    Map currentDevice = Utils().currentDevice(context);
    Size mediaQuerySize = MediaQuery.of(context).size;

    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      try {
        Map<String, dynamic> response;
        bool isProvider = signInController.isProvider;
        if (isProvider) {
          response = await SignInProviderMutation().signInProviderMutation();
        } else {
          response = await SignInClientMutation().signInClientMutation();
        }
        if (response['status']!) {
          Get.offAndToNamed(
            isProvider ? ProviderScreen.routeName : ClientScreen.routeName,
          );
        }
      } catch (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AndroidAlertDialog(
              title: 'Oops!',
              message: Text(
                '$err',
              ),
            );
          },
        );
      }
    }

    return Obx(() {
      if (signInController.isLoading) {
        return const AndroidLoading();
      }
      return currentDevice['isDesktop']
          ? SizedBox(
              height: mediaQuerySize.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AndroidDrawer(),
                  const VerticalDivider(),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 130,
                            decoration: const BoxDecoration(
                              color: Colors.white12,
                            ),
                            child: Center(
                              child: Image.asset(
                                logoImage,
                                fit: BoxFit.cover,
                                height: 80,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidTextField(
                                value: signInController.email.trim(),
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                onInputChange: (input) {
                                  signInController.email = input.trim();
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
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidTextField(
                              value: signInController.password.trim(),
                              label: 'Password',
                              obscureText: !signInController.showPassword,
                              prefixIcon: Icons.password_outlined,
                              onInputChange: (input) {
                                signInController.password = input.trim();
                              },
                              onValidation: (String? input) {
                                if (input == null || input.isEmpty) {
                                  return 'Password is required';
                                }
                                if (input.length < 5) {
                                  return 'Password should be at least 5 characters.';
                                }

                                return null;
                              },
                              suffixIcon: signInController.password.isNotEmpty
                                  ? signInController.showPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined
                                  : null,
                              suffixIconAction: () {
                                signInController.showPassword =
                                    !signInController.showPassword;
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidCheckBox(
                              label: 'Signing up as a service provider?',
                              checked: signInController.isProvider,
                              onChecked: (checked) {
                                signInController.isProvider = checked!;
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidButton(
                              label: 'Sign in',
                              backgroundColor: Theme.of(context).primaryColor,
                              pressed: () async {
                                _submit();
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.225,
                                  child: AndroidButton(
                                    label: 'Forgot password?',
                                    fontSize: 16,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    pressed: () {
                                      Get.toNamed(
                                          RequestPasswordResetScreen.routeName);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.225,
                                  child: AndroidButton(
                                    label: 'Not signed up?',
                                    fontSize: 16,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    pressed: () {
                                      Get.toNamed(SignUpScreen.routeName);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                ],
              ))
          : SingleChildScrollView(
              child: Form(
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
                          signInController.email = input.trim();
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
                      obscureText: !signInController.showPassword,
                      prefixIcon: Icons.password_outlined,
                      onInputChange: (input) {
                        signInController.password = input.trim();
                      },
                      onValidation: (String? input) {
                        if (input == null || input.isEmpty) {
                          return 'Password is required';
                        }
                        if (input.length < 5) {
                          return 'Password should be at least 5 characters.';
                        }

                        return null;
                      },
                      suffixIcon: signInController.password.isNotEmpty
                          ? signInController.showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined
                          : null,
                      suffixIconAction: () {
                        signInController.showPassword =
                            !signInController.showPassword;
                      },
                    ),
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
                        _submit();
                      },
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: mediaQuerySize.width * 0.45,
                          child: AndroidButton(
                            label: 'Forgot password?',
                            fontSize: 16,
                            backgroundColor: Theme.of(context).primaryColor,
                            pressed: () {
                              Get.toNamed(RequestPasswordResetScreen.routeName);
                            },
                          ),
                        ),
                        SizedBox(
                          width: mediaQuerySize.width * 0.45,
                          child: AndroidButton(
                            label: 'Not signed up?',
                            fontSize: 16,
                            backgroundColor: Theme.of(context).primaryColor,
                            pressed: () {
                              Get.toNamed(SignUpScreen.routeName);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
