import 'package:groomzy/model/booking.dart';

class Rating {
  final int id;
  final double rate;
  final String? comment;
  final Booking? booking;

  Rating({
    required this.id,
    this.comment,
    required this.rate,
    this.booking,
  });
}
