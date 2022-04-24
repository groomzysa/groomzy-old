import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/provider_trading_controller.dart';
import 'package:groomzy/model/service.dart' as service_model;
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/screens/signin/signin.dart';

import '../../book/main.dart';

class Service extends StatelessWidget {
  final service_model.Service service;

  Service({
    required this.service,
    Key? key,
  }) : super(key: key);

  final ProviderTradingController providerTradingController = Get.find();
  final ClientController clientController = Get.find();

  @override
  Widget build(BuildContext context) {
    Map currentDevice = Utils().currentDevice(context);
    return GestureDetector(
      onTap: () {
        providerTradingController.selectedService = service;
        if (clientController.clientId == 0) {
          Get.defaultDialog(
              title: 'Oops!',
              content: const Text(
                'You need to sign in first',
              ),
              radius: 0.0,
              actions: [
                GestureDetector(
                  onTap: () {
                    Get.offAndToNamed(
                      SignInScreen.routeName,
                    );
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ]);
        } else {
          Get.toNamed(
            BookScreen.routeName,
          );
        }
      },
      child: Card(
        color: Colors.grey.shade50,
        elevation: 0.5,
        child: currentDevice['isDesktop'] || currentDevice['isTablet']
            ? Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 0.5)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            service.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${service.duration} minutes'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 80,
                      child: Align(alignment: Alignment.centerLeft, child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AutoSizeText(
                          service.description,
                        ),
                      ),),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R${service.price}',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            children: const [
                              Text(
                                'Book',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                size: 30.0,
                                color: Colors.blue,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : ListTile(
                title: Text(service.title),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: Text(service.description),
                ),
                trailing: SizedBox(
                  // height: 80,
                  width: 130.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'R${service.price}',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          const Text(
                            'Book',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_outlined,
                            size: 30.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Text('${service.duration} minutes'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
