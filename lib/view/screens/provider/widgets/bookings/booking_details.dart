import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/heading/heading.dart';

class BookingDetails extends StatelessWidget {
  final String title;
  final String client;
  final BookingStatus bookingStatus;
  final String bookingDate;
  final String bookingTime;
  final String inHouse;

  const BookingDetails({
    required this.title,
    required this.client,
    required this.bookingStatus,
    required this.bookingTime,
    required this.bookingDate,
    required this.inHouse,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bookingData(
        {required String title, required String value, Color? valueColor}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150.0,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          // SizedBox(width: 20.0,),
          SizedBox(
            width: 150.0,
            child: Text(
              value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      );
    }

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 500.0,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AndroidHeading(
                  title: 'Details',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    FontAwesomeIcons.times,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10.0),
            bookingData(title: 'Client:', value: client),
            const SizedBox(height: 10.0),
            bookingData(title: 'Title:', value: title),
            const SizedBox(height: 10.0),
            bookingData(
              title: 'Status:',
              value: '$bookingStatus',
              valueColor: Utils().bookingStatusColor(bookingStatus),
            ),
            const SizedBox(height: 10.0),
            bookingData(title: 'Date time:', value: bookingDate),
            const SizedBox(height: 10.0),
            bookingData(title: 'Time:', value: bookingTime),
            const SizedBox(height: 10.0),
            bookingData(title: 'In house call:', value: inHouse),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
