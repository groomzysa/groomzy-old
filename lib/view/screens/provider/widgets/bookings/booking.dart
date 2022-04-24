import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/provider/booking/booking_cancel_mutation.dart';
import 'package:groomzy/api/graphql/mutations/provider/booking/booking_done_mutation.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/model/service.dart' as service_model;
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/provider/widgets/bookings/booking_details.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/table/table_cell.dart';
import 'package:groomzy/view/widgets/table/table_header.dart';

class Booking extends StatelessWidget {
  final int bookingId;
  final String bookedBy;
  final String bookingDate;
  final String bookingTime;
  final BookingStatus bookingStatus;
  final bool inHouse;
  final service_model.Service service;

  Booking({
    required this.bookingId,
    required this.bookedBy,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingStatus,
    required this.inHouse,
    required this.service,
    Key? key,
  }) : super(key: key);

  final BookController bookController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      try {
        Map<String, dynamic> response = {'status': false};
        if (bookController.done) {
          response =
          await ProviderBookingDoneMutation().providerBookingDoneMutation();
        } else if (bookController.cancel) {
          response =
          await ProviderBookingCancelMutation().providerBookingCancelMutation();
        }

        if (response['status']!) {
          Get.defaultDialog(
            title: 'Info',
            content: Text(
              response['message'],
            ),
            radius: 0,
            actions: [
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                onPressed: () => Get.back(),
              )
            ],
          );
        }
      } catch (err) {
        Get.defaultDialog(
          title: 'Oops!',
          content: Text(
            '$err',
          ),
          radius: 0,
          actions: [
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              onPressed: () => Get.back(),
            )
          ],
        );
      }
    }

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
                    TableValue(value: service.title),
                    TableValue(value: '$bookingDate $bookingTime hrz'),
                    TableValue(
                        value: Utils().mapBookingStatusToString(bookingStatus),
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
                              title: service.title,
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
                            color: Colors.blueGrey,
                          ),
                          Text('View'),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Obx(() {
                    if (bookController.id == bookingId && bookController.done && bookController.isLoading) {
                      return const AndroidLoading();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          if ([BookingStatus.active]
                              .contains(bookingStatus)) {
                            bookController.id = bookingId;
                            bookController.done = true;
                            _submit();
                          }
                        },
                        child: SizedBox(
                          height: 40.0,
                          child: Column(
                            children: [
                              Icon(
                                Icons.done_outline,
                                color: ['Active', 'Pending'].contains(Utils().mapBookingStatusToString(bookingStatus))
                                    ? Colors.blue
                                    : Colors.black12,
                              ),
                              Text(
                                'Done',
                                style: TextStyle(
                                  color:
                                  ['Active', 'Pending'].contains(Utils().mapBookingStatusToString(bookingStatus))
                                      ? null
                                      : Colors.black12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                  const VerticalDivider(),
                  Obx(() {
                    if (bookController.id == bookingId && bookController.cancel && bookController.isLoading) {
                      return const AndroidLoading();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          if ([BookingStatus.active, BookingStatus.pending]
                              .contains(bookingStatus)) {
                            bookController.id = bookingId;
                            bookController.cancel = true;
                            _submit();
                          }
                        },
                        child: SizedBox(
                          height: 40.0,
                          child: Column(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: ['Cancelled', 'Deleted', 'Done']
                                    .contains(Utils().mapBookingStatusToString(bookingStatus))
                                    ? Colors.black12
                                    : Colors.redAccent,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  color: ['Cancelled', 'Deleted', 'Done']
                                      .contains(Utils().mapBookingStatusToString(bookingStatus))
                                      ? Colors.black12
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
