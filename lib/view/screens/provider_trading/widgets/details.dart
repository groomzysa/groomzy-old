import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/staff.dart';
import 'package:groomzy/utils/utils.dart';

class Details extends StatelessWidget {
  Details({
    Key? key,
  }) : super(key: key);

  final ProviderController providerController = Get.find<ProviderController>();

  Widget mapContainer({
    required BuildContext context,
    required String address,
    required double lat,
    required double log,
  }) {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, log),
          zoom: 17,
        ),
        markers: {
          Marker(
            infoWindow: InfoWindow(title: address),
            markerId: MarkerId(address),
            draggable: false,
            position: LatLng(lat, log),
          )
        },
      ),
    );
  }

  Widget tableHeader(String heading, BuildContext context) {
    return TableCell(
      child: Text(
        heading,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Address? address = providerController.provider.address;
      List<Staff>? staffs = providerController.provider.staffs;
      List<DayTime>? dayTimes = providerController.provider.dayTimes ?? [];
      print(address?.address);
      print(address?.longitude);
      print(address?.latitude);

      return Column(
        children: [
          mapContainer(
            context: context,
            address: address?.address ?? '',
            lat: address?.latitude ?? 0,
            log: address?.longitude ?? 0,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Staffers',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            children: [
              if (staffs != null && staffs.isEmpty)
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                  ),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'There are no staff yet.',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              if (staffs != null && staffs.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...staffs
                          .map(
                            (staff) => Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.black12,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        staff.fullName
                                            .split(' ')[0][0]
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(staff.fullName.split(' ')[0].toString()),
                              ],
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Operating day times',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                ...dayTimes
                    .map(
                      (dayTime) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Utils().mapDayToString(dayTime.day.day),
                                style: const TextStyle(color: Colors.black54),
                              ),
                              Text(
                                '${dayTime.time.startTime} -'
                                ' ${dayTime.time.endTime}',
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );
    });
  }
}
