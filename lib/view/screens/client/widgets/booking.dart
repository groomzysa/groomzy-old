import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/client/book_cancel.dart';
import 'package:groomzy/api/graphql/mutations/client/book_delete.dart';
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/client/widgets/booking_details.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/table/table_cell.dart';
import 'package:groomzy/view/widgets/table/table_header.dart';

class Booking extends StatelessWidget {
  final int bookingId;
  final String provider;
  final String bookingDate;
  final String bookingTime;
  final BookingStatus bookingStatus;
  final String bookingDurationUnit;
  final double bookingDuration;
  final bool inHouse;
  final Map service;
  final Function refetchQuery;

  const Booking({
    required this.bookingId,
    required this.provider,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingStatus,
    required this.bookingDurationUnit,
    required this.bookingDuration,
    required this.inHouse,
    required this.service,
    required this.refetchQuery,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      elevation: 1,
      child: Column(
        children: [
          const Divider(height: 0),
          ListTile(
            title: const Text('Provided by:'),
            subtitle: Text(provider),
            trailing: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status:'),
                  Text(
                    Utils().mapBookingStatusToString(bookingStatus),
                    style: TextStyle(
                        color: Utils().bookingStatusColor(bookingStatus)),
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
                    TableValue(value: service['title']),
                    TableValue(value: bookingDate),
                    TableValue(
                      value: '$bookingTime hrz',
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
                            child: BookingDetails(
                              provider: provider,
                              title: service['title'],
                              bookingDate: bookingDate,
                              bookingTime: '$bookingTime hrz',
                              bookingStatus: bookingStatus,
                              bookingDuration:
                                  '$bookingDuration $bookingDurationUnit',
                              inHouse: inHouse ? 'Yes' : 'No',
                              bookingPrice:
                                  'R ${double.parse(service['price'].toString()).toStringAsFixed(2)}',
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
                  Mutation(
                    options: MutationOptions(
                      document:
                          gql(ClientBookCancelMutation().clientBookCancel),
                      update: (
                        GraphQLDataProxy? cache,
                        QueryResult? result,
                      ) {
                        if (result!.hasException) {
                          String errMessage =
                              result.exception!.graphqlErrors[0].message;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AndroidAlertDialog(
                                title: 'Error',
                                message: Text(
                                  errMessage,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      onCompleted: (dynamic clientBookCancelResult) async {
                        if (clientBookCancelResult != null) {
                          String message =
                              clientBookCancelResult['clientBookCancel']
                                  ['message'];
                          if (message.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AndroidAlertDialog(
                                  title: 'Completed',
                                  message: Text(
                                    message,
                                    style: const TextStyle(
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          refetchQuery();
                        }
                      },
                    ),
                    builder: (
                      RunMutation? runClientBookCancelMutation,
                      QueryResult? clientBookCancelResult,
                    ) {
                      if (clientBookCancelResult!.isLoading) {
                        return const AndroidLoading();
                      }
                      return GestureDetector(
                        onTap: () async {
                          if ([BookingStatus.active, BookingStatus.pending].contains(bookingStatus)) {
                            runClientBookCancelMutation!({
                              'bookingId': bookingId,
                              'cancel': true,
                            });
                          }
                        },
                        child: SizedBox(
                          height: 40.0,
                          child: Column(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: [BookingStatus.active, BookingStatus.pending]
                                        .contains(bookingStatus)
                                    ? Colors.redAccent
                                    : Colors.black12,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  color: [BookingStatus.active, BookingStatus.pending]
                                          .contains(bookingStatus)
                                      ? Colors.redAccent
                                      : Colors.black12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const VerticalDivider(),
                  Mutation(
                    options: MutationOptions(
                      document: gql(
                        ClientBookDeleteMutation().clientBookDelete,
                      ),
                      update: (
                        GraphQLDataProxy? cache,
                        QueryResult? result,
                      ) {
                        if (result!.hasException) {
                          String errMessage =
                              result.exception!.graphqlErrors[0].message;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AndroidAlertDialog(
                                title: 'Error',
                                message: Text(
                                  errMessage,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      onCompleted: (dynamic clientBookDeleteResult) async {
                        if (clientBookDeleteResult != null) {
                          String message =
                              clientBookDeleteResult['clientBookDelete']
                                  ['message'];
                          if (message.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AndroidAlertDialog(
                                  title: 'Completed',
                                  message: Text(
                                    message,
                                    style: const TextStyle(
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          refetchQuery();
                        }
                      },
                    ),
                    builder: (
                      RunMutation? runClientBookDeleteMutation,
                      QueryResult? clientBookDeleteResult,
                    ) {
                      return GestureDetector(
                        onTap: () {
                          if (bookingStatus == BookingStatus.cancelled) {
                            runClientBookDeleteMutation!({
                              'bookingId': bookingId,
                              'delete': true,
                            });
                          }
                        },
                        child: SizedBox(
                          height: 40.0,
                          child: Column(
                            children: [
                              Icon(
                                Icons.delete_forever_outlined,
                                color: bookingStatus ==  BookingStatus.cancelled
                                    ? Colors.redAccent
                                    : Colors.black12,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: bookingStatus ==  BookingStatus.cancelled
                                      ? Colors.redAccent
                                      : Colors.black12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
