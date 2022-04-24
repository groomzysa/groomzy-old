import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/client.dart';
import 'package:groomzy/view/screens/provider/widgets/bookings/booking.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:intl/intl.dart';

import 'package:groomzy/api/graphql/queries/provider/provider_bookings_query.dart';

class Bookings extends StatelessWidget {
  Bookings({Key? key}) : super(key: key);

  final GlobalsController globalsController = Get.find();
  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(BookController());

    return FutureBuilder(
      future: ProviderBookingsQuery().getProviderBookings(
        providerId: globalsController.user['id'],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(() => RefreshIndicator(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (providerController.bookings.isEmpty)
                        AndroidCenterHorizontalVertical(
                          screenContent: Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.4,
                            ),
                            width: 250,
                            child: const Text(
                              'You currently have no bookings available.',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      if (providerController.bookings.isNotEmpty)
                        ...providerController.bookings.map(
                          (booking) {
                            Client client = booking.client!;

                            return Column(
                              children: [
                                Booking(
                                  bookingId: booking.id,
                                  bookedBy: client.fullName,
                                  bookingDate: DateFormat.yMd()
                                      .format(booking.bookingTime),
                                  bookingTime: DateFormat.Hm()
                                      .format(booking.bookingTime),
                                  inHouse: booking.inHouse,
                                  service: booking.service,
                                  bookingStatus: booking.status,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            );
                          },
                        ).toList(),
                    ],
                  ),
                ),
                onRefresh: () async {
                  ProviderBookingsQuery().getProviderBookings(
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
