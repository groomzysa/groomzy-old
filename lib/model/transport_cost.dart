import 'package:groomzy/model/booking.dart';

class TransportCost {
  final int id;
  final double distance;
  final double estimatedCost;
  final Booking booking;

  TransportCost({
    required this.id,
    required this.distance,
    required this.estimatedCost,
    required this.booking
  });
}
