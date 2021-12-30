import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/service.dart' as service_model;

import 'service.dart';

class Services extends StatelessWidget {
  const Services({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderController>(
      builder: (c) {
        List<service_model.Service> services = c.provider.services ?? [];
        return Column(
          children: [
            ...services
                .map(
                  (service) => Column(
                    children: [
                      Service(service: service),
                      const Divider(),
                    ],
                  ),
                )
                .toList()
          ],
        );
      },
    );
  }
}
