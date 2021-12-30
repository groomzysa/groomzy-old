import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/controller/client_contoller.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:intl/intl.dart';

import './booking.dart';
import '../../../widgets/loading/loading.dart';

import '../../../../api/graphql/queries/client/client_bookings.dart';

class Bookings extends StatelessWidget {
  Bookings({Key? key}) : super(key: key);

  final ClientController clientController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Query(
        options: QueryOptions(
          document: gql(ClientBookingsQuery().clientBookings),
          variables: {'clientId': clientController.clientId},
        ),
        builder: (
          QueryResult? clientBookingsResult, {
          Future<void> Function()? refetch,
          FetchMore? fetchMore,
        }) {
          String? errorMessage;
          if (clientBookingsResult!.hasException) {
            if (clientBookingsResult.exception!.graphqlErrors.isNotEmpty) {
              errorMessage =
                  clientBookingsResult.exception!.graphqlErrors[0].message;
            }
          }

          if (clientBookingsResult.isLoading) {
            return const AndroidLoading();
          }

          Map<String, dynamic>? data = clientBookingsResult.data;
          List bookings = [];

          if (data != null && data['clientBookings'] != null) {
            bookings = data['clientBookings']['bookings'] ?? [];
          }

          return RefreshIndicator(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  if (bookings.isEmpty)
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.15),
                      child: Text(
                        'No bookings available',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  if (bookings.isNotEmpty)
                    ...bookings.map(
                      (booking) {
                        Map provider = booking['provider'];
                        Map service = booking['service'];
                        int parsedBookingTime =
                            int.parse(booking['bookingTime']);
                        DateTime bookingTime =
                            DateTime.fromMillisecondsSinceEpoch(
                          parsedBookingTime,
                        );
                        return Column(
                          children: [
                            Booking(
                              bookingId: booking['id'],
                              provider: provider['fullName'],
                              bookingDate:
                                  DateFormat.yMEd().format(bookingTime),
                              bookingTime: DateFormat.Hm().format(bookingTime),
                              bookingDurationUnit: service['durationUnit'],
                              bookingDuration:
                                  double.parse(service['duration'].toString()),
                              inHouse: booking['inHouse'],
                              service: booking['service'],
                              bookingStatus: Utils().mapBookingStatus(booking['status']),
                              refetchQuery: refetch!,
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
            onRefresh: refetch!,
          );
        },
      );
    });
  }
}
