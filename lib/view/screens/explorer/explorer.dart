import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/queries/provider/providers.dart';
import 'package:groomzy/controller/explore_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/summary_service_provider_controller.dart';
import 'package:groomzy/view/screens/explorer/widgets/summary_service_provider.dart';
import 'package:groomzy/view/widgets/horizontal_scroll/category_labels.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/search/search.dart';

class Explore extends StatelessWidget {
  Explore({Key? key}) : super(key: key);

  final ProviderController providerController = Get.find();
  final SummaryServiceProviderController summaryServiceProviderController =
      Get.find();
  final ExploreController exploreController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return FutureBuilder(
          future: ProvidersQuery().loadProviders(
            search: exploreController.search,
            category: exploreController.category,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const AndroidCategoryLabels(),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AndroidSearch(),
                            // TODO: ADD FILTERS, Post MVP
                            // AndroidFilters(),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (providerController.providers.isEmpty)
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.15),
                          child: Text(
                            'No providers available',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      if (providerController.providers.isNotEmpty)
                        ...providerController.providers.map(
                          (provider) {
                            return AndroidSummaryService(
                              provider: provider,
                            );
                          },
                        ).toList(),
                    ],
                  ),
                ),
                onRefresh: () async {
                  ProvidersQuery().loadProviders(
                    search: exploreController.search,
                    category: exploreController.category,
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
