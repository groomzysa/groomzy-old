import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';
import 'package:groomzy/api/graphql/mutations/client/client_signup_mutation.dart';
import 'package:groomzy/api/graphql/mutations/provider/provider_signup_mutation.dart';
import 'package:groomzy/controller/signup_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignupController signupController = Get.find();

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
        if (signupController.isProvider) {
          response = await SignUpProviderMutation().signUpProviderMutation();
        } else {
          response = await SignUpClientMutation().signUpClientMutation();
        }
        if (response['status']!) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AndroidAlertDialog(
                title: 'Info',
                message: Text(
                  response['message'],
                ),
                navigateTo: SignInScreen.routeName,
                replacePreviousNavigation: true,
                fromSignUp: true,
              );
            },
          );
        }
      } catch (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            bool alreadyExists = err.toString().contains('exist');
            return AndroidAlertDialog(
              title: 'Oops!',
              message: Text(
                '$err',
              ),
              navigateTo: alreadyExists ? SignInScreen.routeName : null,
              replacePreviousNavigation: alreadyExists ? true : false,
              fromSignUp: alreadyExists ? true : false,
            );
          },
        );
      }
    }

    return Obx(() {
      if (signupController.isLoading) {
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
                              value: signupController.fullName.trim(),
                              label: 'Full name',
                              prefixIcon: Icons.person_outlined,
                              onInputChange: (input) {
                                signupController.fullName = input.trim();
                              },
                              onValidation: (String? input) {
                                if (input == null || input.isEmpty) {
                                  return 'First name is required';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidTextField(
                                value: signupController.email.trim(),
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                onInputChange: (input) {
                                  signupController.email = input.trim();
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
                                value: signupController.phoneNumber.trim(),
                                label: 'Phone number',
                                prefixIcon: Icons.phone_android_outlined,
                                onInputChange: (input) {
                                  signupController.phoneNumber = input.trim();
                                },
                                onValidation: (String? input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Phone number is required';
                                  }

                                  return null;
                                }),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidTextField(
                              value: signupController.password.trim(),
                              label: 'Password',
                              obscureText: !signupController.showPassword,
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
                              },
                              suffixIcon: signupController.password.isNotEmpty
                                  ? signupController.showPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined
                                  : null,
                              suffixIconAction: () {
                                signupController.showPassword =
                                    !signupController.showPassword;
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidCheckBox(
                              label: 'Signing up as a service provider?',
                              checked: signupController.isProvider,
                              onChecked: (checked) {
                                signupController.isProvider = checked!;
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidButton(
                              label: 'Sign up',
                              backgroundColor: Theme.of(context).primaryColor,
                              pressed: () async {
                                _submit();
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          SizedBox(
                            width: mediaQuerySize.width * 0.5,
                            child: AndroidButton(
                              label: 'Already signed up?',
                              backgroundColor: Theme.of(context).primaryColor,
                              pressed: () {
                                Get.toNamed(SignInScreen.routeName);
                              },
                            ),
                          )
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
                      value: signupController.fullName.trim(),
                      label: 'Full name',
                      prefixIcon: Icons.person_outlined,
                      onInputChange: (input) {
                        signupController.fullName = input.trim();
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
                          signupController.email = input.trim();
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
                          signupController.phoneNumber = input.trim();
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
                      obscureText: !signupController.showPassword,
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
                      },
                      suffixIcon: signupController.password.isNotEmpty
                          ? signupController.showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined
                          : null,
                      suffixIconAction: () {
                        signupController.showPassword =
                            !signupController.showPassword;
                      },
                    ),
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
                        _submit();
                      },
                    ),
                    const SizedBox(height: 10.0),
                    AndroidButton(
                      label: 'Already signed up?',
                      backgroundColor: Theme.of(context).primaryColor,
                      pressed: () {
                        Get.toNamed(SignInScreen.routeName);
                      },
                    )
                  ],
                ),
              ),
            );
    });
  }
}
