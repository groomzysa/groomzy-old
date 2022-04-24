import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_operating_times_query.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/operating_time_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/add_operating_time.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/operating_time.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class OperatingTimes extends StatelessWidget {
  OperatingTimes({Key? key}) : super(key: key);

  final GlobalsController globalsController = Get.find();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(OperatingTimeController());

    return FutureBuilder(
      future: ProviderOperatingTimesQuery().getProviderOperatingTimes(
        providerId: globalsController.user['id'],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(() => RefreshIndicator(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: AddOperatingTime(),
                              );
                            },
                          );
                        },
                        child: const ListTile(
                          leading:
                              Icon(Icons.add_outlined, color: Colors.green),
                          title: Text('Click to add business day'),
                        ),
                      ),
                      if (providerController.operatingTimes.isEmpty)
                        Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.3,
                          ),
                          width: 250,
                          child: const Text(
                            'You currently have no business operating times set',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ...providerController.operatingTimes.map((dayTime) {
                        return OperatingTime(dayTime: dayTime);
                      }).toList(),
                    ],
                  ),
                ),
                onRefresh: () async {
                  ProviderOperatingTimesQuery().getProviderOperatingTimes(
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
