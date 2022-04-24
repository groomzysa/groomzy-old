import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/provider/service/add_service_mutation.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/service_controller.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class AddService extends StatelessWidget {
  AddService({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();
  final ServiceController serviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      try {
        Map<String, dynamic> response =
            await AddServiceMutation().addServiceMutation();
        if (response['status']!) {
          Get.back();
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
      if (serviceController.isLoading) {
        return const AndroidLoading();
      }
      return SingleChildScrollView(
        child: Form(
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
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    items: Utils().categories,
                    selectedItem: serviceController.category.isEmpty ? null : serviceController.category,
                    onChanged: (String? input) {
                      serviceController.category = input ?? '';
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Category is required';
                      }

                      return null;
                    },
                    dropdownSearchDecoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category_outlined, color: Colors.grey,),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: 'Category',
                      hintText: 'Select category',
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
                    value: serviceController.title,
                    label: 'title',
                    onInputChange: (String input) {
                      serviceController.title = input;
                    },
                    onValidation: (String? input) {
                      if (input == null || input.isEmpty) {
                        return 'Title is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  AndroidTextField(
                    value: serviceController.description,
                    label: 'description',
                    onInputChange: (String input) {
                      serviceController.description = input;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: serviceController.price.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    cursorColor: Colors.grey,
                    onChanged: (String? input) {
                      serviceController.price = input != null && input.isNotEmpty
                          ? double.parse(input)
                          : 0.0;
                    },
                    validator: (String? input) {
                      if (input == null || input.isEmpty) {
                        return 'Price is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: serviceController.duration.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    cursorColor: Colors.grey,
                    onChanged: (String? input) {
                      serviceController.duration = input != null && input.isNotEmpty
                          ? double.parse(input)
                          : 0.0;
                    },
                    validator: (String? input) {
                      if (input == null || input.isEmpty) {
                        return 'Duration is required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    items: const ['min', 'hrz'],
                    maxHeight: 120.0,
                    selectedItem: serviceController.durationUnit.isEmpty ? null : serviceController.durationUnit,
                    onChanged: (String? input) {
                      serviceController.durationUnit = input ?? '';
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Duration unit is required';
                      }

                      return null;
                    },
                    dropdownSearchDecoration: const InputDecoration(
                      prefixIcon: Icon(Icons.timer_outlined, color: Colors.grey,),
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: "Duration unit",
                      hintText: "Select duration unit",
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
                  AndroidCheckBox(
                    label: 'In house call?',
                    checked: serviceController.inHouse,
                    onChecked: (bool? input) {
                      serviceController.inHouse = input ?? false;
                    },
                  ),
                  AndroidButton(
                    label: 'Add',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
