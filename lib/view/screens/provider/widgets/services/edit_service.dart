import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/provider/service/edit_service_mutation.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/service_controller.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class EditService extends StatelessWidget {
  EditService({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();
  final ServiceController serviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();

      try {
        Map<String, dynamic> response =
        await EditServiceMutation().editServiceMutation();
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
                popTimes: 2,
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
              popTimes: 2,
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
          key: formKey,
          child: SafeArea(child: Container(
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
                    // showSelectedItem: true,
                    items: Utils().categories,

                    onChanged: (String? input) {
                      serviceController.category = input ?? serviceController.category;
                    },
                    selectedItem: serviceController.category,
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Category",
                      hintText: "Select category",
                      labelStyle: TextStyle(color: Colors.grey),
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
                    onChanged: (String input) {
                      serviceController.price = double.parse(input);
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
                    onChanged: (String input) {
                      serviceController.duration = double.parse(input);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    // showSelectedItem: true,
                    items: const ['min', 'hrz'],
                    onChanged: (String? input) {
                      serviceController.durationUnit = input ?? serviceController.durationUnit;
                    },
                    maxHeight: 120.0,
                    selectedItem: serviceController.durationUnit,
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Duration unit",
                      hintText: "Select duration unit",
                      labelStyle: TextStyle(color: Colors.grey),
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
                    label: 'Edit',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit();
                    },
                  ),
                ],
              ),
            ),
          ),),
        ),
      );
    });
  }
}
