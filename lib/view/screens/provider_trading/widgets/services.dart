import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_services_query.dart';
import 'package:groomzy/api/graphql/queries/provider/providers_query.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/screens/provider_trading/main.dart';
import 'package:universal_html/html.dart' as html;
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

import 'service.dart';

class Services extends StatelessWidget {
  Services({
    Key? key,
  }) : super(key: key);

  final ProviderController providerController = Get.find<ProviderController>();
  final servicesLocalStorage = GetStorage();

  @override
  Widget build(BuildContext context) {
    html.window.onBeforeUnload.listen((event) {
      servicesLocalStorage.write(
          'providerId', providerController.providerId);
    });

    if (providerController.providerId == 0) {
      providerController.providerId = servicesLocalStorage.read('providerId');
    }

    Map currentDevice = Utils().currentDevice(context);

    return Obx(
      () {
        return FutureBuilder(
          future: ProviderServicesQuery().getProviderServices(
            providerId: providerController.providerId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: currentDevice['isDesktop'] || currentDevice['isTablet']
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              if (providerController.providers.isNotEmpty)
                                Flexible(
                                  child: GridView.count(
                                    crossAxisCount:
                                        currentDevice['isDesktop'] ? 3 : 2,
                                    children: [
                                      ...providerController.providerServices
                                          .map(
                                            (providerService) => Column(
                                              children: [
                                                Service(
                                                  service:
                                                      providerService.service!,
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList()
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            ...providerController.providerServices
                                .map(
                                  (providerService) => Column(
                                    children: [
                                      Service(
                                        service: providerService.service!,
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                )
                                .toList()
                          ],
                        ),
                ),
                onRefresh: () async {
                  ProviderServicesQuery().getProviderServices(
                    providerId: providerController.providerId,
                  );
                },
              );
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
      },
    );
  }
}
