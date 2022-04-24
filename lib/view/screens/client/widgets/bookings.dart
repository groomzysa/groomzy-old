import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/center_horizontal_vertical/center_horizontal_vertical.dart';
import 'package:intl/intl.dart';

import './booking.dart';
import '../../../widgets/loading/loading.dart';

import '../../../../api/graphql/queries/client/client_bookings_query.dart';

class Bookings extends StatelessWidget {
  Bookings({Key? key}) : super(key: key);

  final ClientController clientController = Get.find();
  final GlobalsController globalsController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.put(BookController());

    return FutureBuilder(
      future: ClientBookingsQuery().getClientBookings(
        clientId: globalsController.user['id'],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(() => RefreshIndicator(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (clientController.bookings.isEmpty)
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
                      if (clientController.bookings.isNotEmpty)
                        ...clientController.bookings.map(
                          (booking) {
                            return Column(
                              children: [
                                Booking(
                                  booking: booking,
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
                  ClientBookingsQuery().getClientBookings(
                    clientId: globalsController.user['id'],
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
