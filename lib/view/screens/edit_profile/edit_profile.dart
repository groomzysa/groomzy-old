import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/client/client_signup_mutation.dart';
import 'package:groomzy/api/graphql/mutations/provider/provider_edit_profile_mutation.dart';
import 'package:groomzy/controller/EditProfileController.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/heading/heading.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';
import 'package:geocoding/geocoding.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final EditProfileController editProfileController = Get.find();
  final GlobalsController globalsController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      List<Location> locations = await locationFromAddress(
        '${editProfileController.streetNumber}, ${editProfileController.streetName}, ${editProfileController.suburbName}, ${editProfileController.cityName}, ${editProfileController.provinceName}, ${editProfileController.areaCode} ',
      );

      editProfileController.latitude = locations[0].latitude;
      editProfileController.longitude = locations[0].longitude;

      try {
        editProfileController.isProvider =
            globalsController.user['role'] == 'Provider';
        Map<String, dynamic> response;
        if (editProfileController.isProvider) {
          response =
              await EditProfileProviderMutation().editProfileProviderMutation();
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
                popTimes: 1,
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

    return Obx(
      () {
        if (editProfileController.isLoading) {
          return const AndroidLoading();
        }
        Map? address = globalsController.user['address'];

        return SingleChildScrollView(
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
                const AndroidHeading(title: 'Personal details'),
                const Divider(),
                AndroidTextField(
                  value: editProfileController.fullName.isEmpty
                      ? globalsController.user['fullName'] ?? ''
                      : editProfileController.fullName,
                  label: 'Full name',
                  prefixIcon: Icons.person_outlined,
                  onInputChange: (input) {
                    editProfileController.fullName = input.trim();
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
                  value: globalsController.user['email'] ?? '',
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  enabled: false,
                ),
                const SizedBox(height: 10.0),
                AndroidTextField(
                  value: globalsController.user['phoneNumber'] ?? '',
                  label: 'Phone number',
                  prefixIcon: Icons.phone_android_outlined,
                  enabled: false,
                ),
                const SizedBox(height: 10.0),
                const AndroidHeading(title: 'Address'),
                const Divider(),
                DropdownSearch<String>(
                  mode: Mode.MENU,
                  maxHeight: 50,
                  items: Utils().provinces,
                  selectedItem: editProfileController.provinceName.isEmpty
                      ? address != null
                          ? address['provinceName']
                          : null
                      : editProfileController.provinceName,
                  onChanged: (String? input) {
                    editProfileController.provinceName = input ?? '';
                  },
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Province is required';
                    }

                    return null;
                  },
                  dropdownSearchDecoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.real_estate_agent_outlined,
                      color: Colors.grey,
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: 'Province',
                    hintText: 'Select province',
                    contentPadding:
                        EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownSearch<String>(
                  mode: Mode.MENU,
                  maxHeight: 50,
                  items: Utils().cities()[editProfileController
                              .provinceName.isEmpty
                          ? address != null ?address['provinceName'] : ''
                          : editProfileController.provinceName] ??
                      [],
                  selectedItem: editProfileController.cityName.isEmpty
                      ? address != null
                          ? address['cityName']
                          : null
                      : editProfileController.cityName,
                  onChanged: (String? input) {
                    editProfileController.cityName = input ?? '';
                  },
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'City is required';
                    }

                    return null;
                  },
                  dropdownSearchDecoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_city_outlined,
                      color: Colors.grey,
                    ),
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: 'City',
                    hintText: 'Select city',
                    contentPadding:
                        EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                AndroidTextField(
                  value: editProfileController.streetNumber.isEmpty
                      ? address != null
                          ? address['streetNumber'] ?? ''
                          : ''
                      : editProfileController.streetNumber,
                  label: 'Building/Street no',
                  prefixIcon: Icons.edit_road_outlined,
                  onInputChange: (input) {
                    editProfileController.streetNumber = input.trim();
                  },
                  onValidation: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Building / Street number is required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                AndroidTextField(
                  value: editProfileController.streetName.isEmpty
                      ? address != null
                          ? address['streetName'] ?? ''
                          : ''
                      : editProfileController.streetName,
                  label: 'Building/Street name',
                  prefixIcon: Icons.house_outlined,
                  onInputChange: (input) {
                    editProfileController.streetName = input.trim();
                  },
                  onValidation: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Building / Street name is required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                AndroidTextField(
                  value: editProfileController.suburbName.isEmpty
                      ? address != null
                          ? address['suburbName'] ?? ''
                          : ''
                      : editProfileController.suburbName,
                  label: 'Town/Suburb name',
                  prefixIcon: Icons.other_houses_outlined,
                  onInputChange: (input) {
                    editProfileController.suburbName = input.trim();
                  },
                  onValidation: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Town / Suburb name is required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                AndroidTextField(
                  value: editProfileController.areaCode.isEmpty
                      ? address != null
                          ? address['areaCode'] ?? ''
                          : ''
                      : editProfileController.areaCode,
                  label: 'Area code',
                  prefixIcon: Icons.numbers_outlined,
                  onInputChange: (input) {
                    editProfileController.areaCode = input.trim();
                  },
                  onValidation: (String? input) {
                    if (input == null || input.isEmpty) {
                      return 'Area code is required';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                AndroidButton(
                  label: 'Edit profile',
                  backgroundColor: Theme.of(context).primaryColor,
                  pressed: () async {
                    _submit();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
