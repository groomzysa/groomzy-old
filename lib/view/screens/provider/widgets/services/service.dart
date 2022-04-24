import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/service_controller.dart';
import 'package:groomzy/model/category.dart';
import 'package:groomzy/view/screens/provider/widgets/services/delete_service.dart';
import 'package:groomzy/view/screens/provider/widgets/services/edit_service.dart';
import 'package:groomzy/model/service.dart' as service_model;

class Service extends StatelessWidget {
  final service_model.Service service;
  final Category category;

  Service({
    required this.service,
    required this.category,
    Key? key,
  }) : super(key: key);

  final ServiceController serviceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      elevation: 0.5,
      child: Column(
        children: [
          const Divider(
            height: 0.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              subtitle: Table(
                children: [
                  const TableRow(children: [
                    TableCell(
                      child: Text(
                        'title',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Price',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Duration',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'In-house',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                  ]),
                  const TableRow(children: [
                    TableCell(
                      child: Divider(),
                    ),
                    TableCell(
                      child: Divider(),
                    ),
                    TableCell(
                      child: Divider(),
                    ),
                    TableCell(
                      child: Divider(),
                    ),
                  ]),
                  TableRow(children: [
                    TableCell(
                      child: Text(
                        service.title,
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'R${service.price}',
                      ),
                    ),
                    TableCell(
                      child: Text(
                        '${service.duration} ${service.durationUnit}',
                      ),
                    ),
                    TableCell(
                      child: Text(
                        service.inHouse ? 'Yes' : 'No',
                      ),
                    ),
                  ])
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.only(top: 10.0),
                width: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        serviceController.id = service.id;
                        serviceController.title = service.title;
                        serviceController.description = service.description;
                        serviceController.duration = service.duration;
                        serviceController.durationUnit = service.durationUnit;
                        serviceController.inHouse = service.inHouse;
                        serviceController.price = service.price;
                        serviceController.category = category.category;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: EditService(),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.amber,
                      ),
                    ),
                    const VerticalDivider(),
                    GestureDetector(
                      onTap: () {
                        serviceController.id = service.id;
                        serviceController.category = category.category;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteService();
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
