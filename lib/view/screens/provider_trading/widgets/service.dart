import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/provider_trading_controller.dart';
import 'package:groomzy/model/service.dart' as service_model;

import '../../book/main.dart';

class Service extends StatelessWidget {
  final service_model.Service service;

  Service({
    required this.service,
    Key? key,
  }) : super(key: key);

  final ProviderTradingController providerTradingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        providerTradingController.selectedService = service;
        Get.toNamed(
          BookScreen.routeName,
        );
      },
      child: Card(
        color: Colors.grey.shade50,
        elevation: 0.5,
        child: ListTile(
          title: Text(service.title!),
          subtitle: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
            ),
            child: Text(service.description!),
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
                const SizedBox(height: 5.0),
                Text('${service.duration} minutes'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
