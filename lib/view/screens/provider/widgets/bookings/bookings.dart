import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/view/screens/provider/widgets/bookings/booking.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:intl/intl.dart';

import 'package:groomzy/api/graphql/queries/provider/provider_bookings.dart';

class Bookings extends StatelessWidget {
  final int providerId;

  const Bookings({required this.providerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(ProviderBookingsQuery().providerBookings),
          variables: {'providerId': providerId}),
      builder: (
        QueryResult? providerBookingsResult, {
        Future<void> Function()? refetch,
        FetchMore? fetchMore,
      }) {
        String? errorMessage;
        if (providerBookingsResult!.hasException) {
          if (providerBookingsResult.exception!.graphqlErrors.isNotEmpty) {
            errorMessage =
                providerBookingsResult.exception!.graphqlErrors[0].message;
          }
        }

        if (providerBookingsResult.isLoading) {
          return const AndroidLoading();
        }

        Map<String, dynamic>? data = providerBookingsResult.data;
        List bookings = [];

        if (data != null && data['providerBookings'] != null) {
          bookings = data['providerBookings']['bookings'] ?? [];
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
                      Map client = booking['client'];
                      int parsedBookingTime = int.parse(booking['bookingTime']);
                      DateTime bookingTime =
                          DateTime.fromMillisecondsSinceEpoch(
                        parsedBookingTime,
                      );
                      return Column(
                        children: [
                          Booking(
                            bookingId: booking['id'],
                            bookedBy: client['fullName'],
                            bookingDate: DateFormat.yMd().format(bookingTime),
                            bookingTime: DateFormat.Hm().format(bookingTime),
                            inHouse: booking['inHouse'],
                            service: booking['service'],
                            bookingStatus: booking['status'],
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
  }
}
