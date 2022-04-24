import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/heading/heading.dart';
import 'package:intl/intl.dart';

class BookingDetails extends StatelessWidget {
  final Booking booking;

  const BookingDetails({
    required this.booking,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bookingData(
        {required String title, required String value, Color? valueColor}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor),
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
            bookingData(
                title: 'Provider:', value: booking.provider?.fullName ?? ''),
            const SizedBox(height: 10.0),
            bookingData(title: 'Title:', value: booking.service.title),
            const SizedBox(height: 10.0),
            bookingData(title: 'Price:', value: 'R${booking.service.price}'),
            const SizedBox(height: 10.0),
            bookingData(
              title: 'Status:',
              value: Utils().mapBookingStatusToString(booking.status),
              valueColor: Utils().bookingStatusColor(booking.status),
            ),
            const SizedBox(height: 10.0),
            bookingData(
                title: 'Date:',
                value: DateFormat.yMEd().format(booking.bookingTime)),
            const SizedBox(height: 10.0),
            bookingData(
                title: 'Time:',
                value: DateFormat.Hm().format(booking.bookingTime)),
            const SizedBox(height: 10.0),
            bookingData(
                title: 'Duration:', value: '${booking.service.duration.toString()} ${booking.service.durationUnit}'),
            const SizedBox(height: 10.0),
            bookingData(
                title: 'In house call:', value: booking.inHouse ? 'Yes' : 'No'),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
