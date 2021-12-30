import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/service/edit_service.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class EditService extends StatelessWidget {
  final int serviceId;
  final String title;
  final String description;
  final String category;
  final double price;
  final double duration;
  final String durationUnit;
  final bool inHouse;

  EditService({
    required this.serviceId,
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.durationUnit,
    required this.inHouse,
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {

    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            editService}) async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();

      editService!({
        'serviceId': serviceId,
        'category': category,
        'title': title,
        'description': description,
        'duration': duration,
        'durationUnit': durationUnit,
        'price': price,
        'inHouse': inHouse,
      });
    }

    return Mutation(
        options: MutationOptions(
          document: gql(
            EditServiceMutation().editService,
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
          onCompleted: (dynamic editServiceResult) async {
            if (editServiceResult != null) {
              String message = editServiceResult['editService']['message'];
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
          RunMutation? runEditServiceMutation,
          QueryResult? editServiceResult,
        ) {
          if (editServiceResult!.isLoading) {
            return const AndroidLoading();
          }
          return Form(
            key: formKey,
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
                      onChanged: (String? input) {
                        // _category.value = input;
                      },
                      selectedItem: '_category.value' ?? category,
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
                      value: '_title.value' ?? title,
                      label: 'title',
                      onInputChange: (String? input) {
                        // _title.value = input;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    AndroidTextField(
                      value: '_description.value' ?? description,
                      label: 'description',
                      onInputChange: (String? input) {
                        // _description.value = input;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: '_price.value' != null
                          ?' _price.value.toString()'
                          : price.toString(),
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
                        // _price.value =
                        //     input != null ? double.parse(input) : null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      initialValue: '_duration.value' != null
                          ? '_duration.value.toString()'
                          : duration.toString(),
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
                        // _duration.value =
                        //     input != null ? double.parse(input) : null;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    DropdownSearch<String>(
                      mode: Mode.MENU,
                      // showSelectedItem: true,
                      items: const ['min', 'hrz'],
                      label: "Duration unit",
                      hint: "Select duration unit",
                      onChanged: (String? input) {
                        // _durationUnit.value = input;
                      },
                      maxHeight: 120.0,
                      selectedItem:' _durationUnit.value' ?? durationUnit,
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
                        // _inHouse.value = input ?? false;
                      },
                    ),
                    AndroidButton(
                      label: 'Edit',
                      backgroundColor: Theme.of(context).primaryColor,
                      pressed: () {
                        _submit(editService: runEditServiceMutation);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
