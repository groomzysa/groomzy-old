import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/service/add_service.dart';
import 'package:groomzy/controller/provider_controller.dart';
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

  @override
  Widget build(BuildContext context) {

    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            addService}) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();

      addService!({
        'category': '_category.value',
        'title': '_title.value',
        'description': '_description.value',
        'duration': '_duration.value',
        'durationUnit': '_durationUnit.value',
        'price': '_price.value',
        'inHouse': '_inHouse.value',
      });
    }

    return Mutation(
      options: MutationOptions(
        document: gql(
          AddServiceMutation().addService,
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
        onCompleted: (dynamic addServiceResult) async {
          if (addServiceResult != null) {
            String message = addServiceResult['addService']['message'];
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
        RunMutation? runAddServiceMutation,
        QueryResult? addServiceResult,
      ) {
        if (addServiceResult!.isLoading) {
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
                  DropdownSearch<String>(
                    mode: Mode.MENU,
                    // showSelectedItem: true,
                    items: Utils().categories(),
                    label: "Category",
                    hint: "Select category",
                    selectedItem: '_category.value',
                    onChanged: (String? input) {
                      // _category.value = input;
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Category is required';
                      }

                      return null;
                    },
                    // autoFocusSearchBox: false,
                    dropdownSearchDecoration: const InputDecoration(
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
                    value: '_title.value',
                    label: 'title',
                    onInputChange: (String input) {
                      // _title.value = input;
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
                    value: '_description.value',
                    label: 'description',
                    onInputChange: (String input) {
                      // _description.value = input;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    initialValue: '_price.value?.toString()',
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
                      // _price.value = input != null && input.isNotEmpty
                      //     ? double.parse(input)
                      //     : 0.0;
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
                    initialValue: '_duration.value?.toString()',
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
                      // _duration.value = input != null && input.isNotEmpty
                      //     ? double.parse(input)
                      //     : 0.0;
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
                    // showSelectedItem: true,
                    items: const ['min', 'hrz'],
                    label: "Duration unit",
                    hint: "Select duration unit",
                    maxHeight: 120.0,
                    selectedItem: '_durationUnit.value',
                    onChanged: (String? input) {
                      // _durationUnit.value = input;
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Duration unit is required';
                      }

                      return null;
                    },
                    dropdownSearchDecoration: const InputDecoration(
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
                    checked: false,
                    onChecked: (bool? input) {
                      // _inHouse.value = input!;
                    },
                  ),
                  AndroidButton(
                    label: 'Add',
                    backgroundColor: Theme.of(context).primaryColor,
                    pressed: () {
                      _submit(addService: runAddServiceMutation);
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
