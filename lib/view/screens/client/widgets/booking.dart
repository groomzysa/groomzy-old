import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/client/booking_cancel_mutation.dart';
import 'package:groomzy/api/graphql/mutations/client/booking_delete_mutation.dart';
import 'package:groomzy/api/graphql/mutations/client/booking_rate_mutation.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/model/booking.dart' as booking_model;
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/client/widgets/booking_details.dart';
import 'package:groomzy/view/screens/client/widgets/rating.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/table/table_cell.dart';
import 'package:groomzy/view/widgets/table/table_header.dart';
import 'package:intl/intl.dart';

class Booking extends StatelessWidget {
  final booking_model.Booking booking;

  Booking({
    required this.booking,
    Key? key,
  }) : super(key: key);

  final BookController bookController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      try {
        Map<String, dynamic> response = {'status': false};
        if (bookController.cancel) {
          response =
              await ClientBookingCancelMutation().clientBookingCancelMutation();
        } else if (bookController.delete) {
          response =
              await ClientBookingDeleteMutation().clientBookingDeleteMutation();
        } else if (bookController.rate) {
          response =
              await ClientBookingRateMutation().clientBookingRateMutation();
        }

        if (response['status']!) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AndroidAlertDialog(
                title: 'Info',
                message: Text(
                  response['message'],
                ),
                popTimes: 2,
              );
            },
          );
        }
      } catch (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AndroidAlertDialog(
              title: 'Oops!',
              message: Text(
                '$err',
              ),
              popTimes: 2,
            );
          },
        );
      }
    }

    return Card(
      color: Colors.grey.shade50,
      elevation: 1,
      child: Column(
        children: [
          const Divider(height: 0),
          ListTile(
            title: const Text('Provided by:'),
            subtitle: Text(booking.provider?.fullName ?? ''),
            trailing: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status:'),
                  Text(
                    Utils().mapBookingStatusToString(booking.status),
                    style: TextStyle(
                      color: Utils().bookingStatusColor(booking.status),
                    ),
                  )
                ],
              ),
            ),
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
                    TableHeader(header: 'Date'),
                    TableHeader(header: 'Time'),
                  ],
                ),
                const TableRow(
                  children: [
                    Divider(),
                    Divider(),
                    Divider(),
                  ],
                ),
                TableRow(
                  children: [
                    TableValue(value: booking.service.title),
                    TableValue(
                      value: DateFormat.yMEd().format(
                        booking.bookingTime,
                      ),
                    ),
                    TableValue(
                      value: '${DateFormat.Hm().format(
                        booking.bookingTime,
                      )} hrz',
                    ),
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
                            child: BookingDetails(booking: booking),
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
                    if (bookController.id == booking.id &&
                        bookController.rate &&
                        bookController.isLoading) {
                      return const AndroidLoading();
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Rating(
                                  booking: booking,
                                  submit: _submit,
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox(
                          height: 40.0,
                          child: Column(
                            children: [
                              Icon(
                                Icons.star_half_outlined,
                                color: [
                                  BookingStatus.done,
                                  BookingStatus.cancelled
                                ].contains(booking.status)
                                    ? Colors.lightGreen
                                    : Colors.black12,
                              ),
                              Text(
                                'Rate',
                                style: TextStyle(
                                  color: [
                                    BookingStatus.done,
                                    BookingStatus.cancelled
                                  ].contains(booking.status)
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
                  /* Edit will be done post MVP */
                  // const VerticalDivider(),
                  // GestureDetector(
                  //   onTap: () {
                  //     // View booking details
                  //   },
                  //   child: SizedBox(
                  //     height: 40.0,
                  //     child: Column(
                  //       children: const [
                  //         Icon(
                  //           Icons.edit_outlined,
                  //           color: Colors.orange,
                  //         ),
                  //         Text('Edit'),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const VerticalDivider(),
                  Obx(() {
                    if (bookController.id == booking.id &&
                        bookController.cancel &&
                        bookController.isLoading) {
                      return const AndroidLoading();
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          if ([BookingStatus.active, BookingStatus.pending]
                              .contains(booking.status)) {
                            bookController.id = booking.id;
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
                                color: [
                                  BookingStatus.active,
                                  BookingStatus.pending
                                ].contains(booking.status)
                                    ? Colors.redAccent
                                    : Colors.black12,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  color: [
                                    BookingStatus.active,
                                    BookingStatus.pending
                                  ].contains(booking.status)
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
                  Obx(
                    () {
                      if (bookController.id == booking.id &&
                          bookController.delete &&
                          bookController.isLoading) {
                        return const AndroidLoading();
                      } else {
                        return GestureDetector(
                          onTap: () {
                            if (booking.status == BookingStatus.cancelled) {
                              bookController.id = booking.id;
                              bookController.delete = true;
                              _submit();
                            }
                          },
                          child: SizedBox(
                            height: 40.0,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delete_forever_outlined,
                                  color:
                                      booking.status == BookingStatus.cancelled
                                          ? Colors.redAccent
                                          : Colors.black12,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: booking.status ==
                                            BookingStatus.cancelled
                                        ? null
                                        : Colors.black12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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
