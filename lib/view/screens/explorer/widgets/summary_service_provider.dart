import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/provider.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';

import 'package:groomzy/controller/summary_service_provider_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/explorer/widgets/rating.dart';
import 'package:groomzy/view/screens/provider_trading/main.dart';

class AndroidSummaryService extends StatelessWidget {
  final Provider provider;

  AndroidSummaryService({
    required this.provider,
    Key? key,
  }) : super(key: key);

  final ProviderController providerController = Get.find<ProviderController>();
  final SummaryServiceProviderController summaryServiceProviderController =
      Get.find<SummaryServiceProviderController>();

  @override
  Widget build(BuildContext context) {
    Address? address = provider.address;
    Map providerRating = Utils().providerRating(provider.ratings);

    bool hasAddress() {
      if (address == null) {
        return false;
      }
      if (address.streetNumber == null ||
          address.streetName == null ||
          address.suburbName == null ||
          address.cityName == null ||
          address.provinceName == null ||
          address.areaCode == null ||
          address.latitude == null ||
          address.longitude == null) {
        return false;
      }
      return true;
    }

    return FutureBuilder(
      future: summaryServiceProviderController.getDistance(
        address?.latitude,
        address?.longitude,
          hasAddress()
      ),
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: GestureDetector(
                      onTap: () async {
                        double? latitude = address?.latitude;
                        double? longitude = address?.longitude;

                        if (latitude != null && longitude != null) {
                          MapsLauncher.launchCoordinates(latitude, longitude);

                          // TODO This should be in the common utils expanding to other map types.
                          // var googleMap =
                          //     await MapLauncher.isMapAvailable(MapType.google);
                          // if (googleMap != null && googleMap) {
                          //   await MapLauncher.showDirections(
                          //     mapType: MapType.google,
                          //     destination: Coords(latitude, longitude),
                          //     destinationTitle: hasAddress()
                          //         ? '${address?.streetNumber}, ${address?.streetName}, ${address?.suburbName}, ${address?.cityName}, ${address?.provinceName}, ${address?.areaCode}'
                          //         : '',
                          //   );
                          // }
                        }
                      },
                      child: const Icon(Icons.location_on_outlined),
                    ),
                    title: Text(provider.fullName!),
                    subtitle: Text(
                      hasAddress()
                          ? '${address?.streetNumber}, ${address?.streetName}, ${address?.suburbName}, ${address?.cityName}, ${address?.provinceName}, ${address?.areaCode}'
                          : '',
                    ),
                    trailing: hasAddress() &&
                            summaryServiceProviderController.isLoading
                        ? SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Text(
                            snapshot.hasData ? '~${snapshot.data} km' : '~~~',
                          ),
                  ),
                  SizedBox(
                    height: Utils().currentDevice(context)['isDesktop']! ? 300 : 180,
                    width: double.infinity,
                    child: GestureDetector(
                      child: Image.asset(
                        placeholderImage,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        providerController.provider = provider;
                        providerController.providerId = provider.id!;
                        Get.toNamed(
                          ProviderTradingScreen.routeName,
                        );
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Rating(
                        numberOfRatedBookings: provider.ratings?.length ?? 0,
                        ratingCounts: providerRating['ratingCounts'] ?? 0,
                        ratingPercentage: double.parse(
                            providerRating['ratingPercentage'] ?? '0'),
                        ratingStatus: providerRating['ratingStatus'] ?? '',
                        ratingColor:
                            providerRating['ratingColor'] ?? Colors.grey,
                        ratingIcon: providerRating['ratingIcon'] ??
                            Icons.star_border_outlined,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
