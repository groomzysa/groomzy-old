import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_services_query.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/service_controller.dart';
import 'package:groomzy/model/category.dart';
import 'package:groomzy/model/service.dart' as service_model;
import 'package:groomzy/view/screens/provider/widgets/services/add_service.dart';
import 'package:groomzy/view/screens/provider/widgets/services/service.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class Services extends StatelessWidget {
  Services({Key? key}) : super(key: key);
  final ProviderController providerController = Get.find();
  final GlobalsController globalsController = Get.find();
  final ServiceController serviceController = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProviderServicesQuery().getProviderServices(
        providerId: globalsController.user['id'],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(() => RefreshIndicator(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: AddService(),
                              );
                            },
                          );
                        },
                        child: const ListTile(
                          leading:
                              Icon(Icons.add_outlined, color: Colors.green),
                          title: Text('Add new service'),
                        ),
                      ),
                      if (providerController.providerServices.isEmpty)
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.3),
                          width: 250,
                          child: const Text(
                            'You currently have no services listed.',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ...providerController.providerServices.map(
                        (_service) {
                          service_model.Service service = _service.service!;
                          Category category = _service.category!;
                          return Column(
                            children: [
                              Service(
                                service: service,
                                category: category,
                              ),
                              const SizedBox(
                                height: 5.0,
                              )
                            ],
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
                onRefresh: () async {
                  ProviderServicesQuery().getProviderServices(
                    providerId: globalsController.user['id'],
                  );
                },
              ));
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
          );
        }
        return const AndroidLoading();
      },
    );
  }
}
