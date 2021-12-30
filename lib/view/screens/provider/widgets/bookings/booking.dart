import 'package:flutter/material.dart';
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/provider/widgets/bookings/booking_details.dart';
import 'package:groomzy/view/widgets/table/table_cell.dart';
import 'package:groomzy/view/widgets/table/table_header.dart';

class Booking extends StatelessWidget {
  final int bookingId;
  final String bookedBy;
  final String bookingDate;
  final String bookingTime;
  final BookingStatus bookingStatus;
  final bool inHouse;
  final Map service;

  const Booking({
    required this.bookingId,
    required this.bookedBy,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingStatus,
    required this.inHouse,
    required this.service,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      elevation: 1,
      child: Column(
        children: [
          const Divider(
            height: 0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              top: 10.0,
              bottom: 10.0,
            ),
            child: Table(
              children: [
                const TableRow(
                  children: [
                    TableHeader(header: 'Title'),
                    TableHeader(header: 'Date time'),
                    TableHeader(header: 'Status'),
                    TableHeader(header: 'Client'),
                  ],
                ),
                const TableRow(
                  children: [
                    Divider(),
                    Divider(),
                    Divider(),
                    Divider(),
                  ],
                ),
                TableRow(
                  children: [
                    TableValue(value: service['title']),
                    TableValue(value: '$bookingDate $bookingTime hrz'),
                    TableValue(
                        value: '$bookingStatus',
                        textColor: Utils().bookingStatusColor(bookingStatus)),
                    TableValue(value: bookedBy),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      // View booking details
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: BookingDetails(
                              client: bookedBy,
                              title: service['title'],
                              bookingDate: bookingDate,
                              bookingTime: '$bookingTime hrz',
                              bookingStatus: bookingStatus,
                              inHouse: inHouse ? 'Yes' : 'No',
                            ),
                          );
                        },
                      );
                    },
                    child: SizedBox(
                      height: 40.0,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.blue,
                          ),
                          Text('View'),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  GestureDetector(
                    onTap: () {
                      // Booking done
                    },
                    child: SizedBox(
                      height: 40.0,
                      child: Column(
                        children: [
                          Icon(
                            Icons.done_outline,
                            color: ['Active', 'Pending'].contains(bookingStatus)
                                ? Colors.green
                                : Colors.black12,
                          ),
                          Text(
                            'Done',
                            style: TextStyle(
                              color:
                                  ['Active', 'Pending'].contains(bookingStatus)
                                      ? null
                                      : Colors.black12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  GestureDetector(
                    onTap: () {
                      // Booking cancel
                    },
                    child: SizedBox(
                      height: 40.0,
                      child: Column(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: ['Cancelled', 'Deleted', 'Done']
                                    .contains(bookingStatus)
                                ? Colors.black12
                                : Colors.redAccent,
                          ),
                          Text(
                            'Cancel',
                            style: TextStyle(
                              color: ['Cancelled', 'Deleted', 'Done']
                                      .contains(bookingStatus)
                                  ? Colors.black12
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
