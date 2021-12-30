
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/service.dart';

class Staff {
  final int id;
  final String fullName;
  final List<Booking>? bookings;
  final List<Service>? services;
  final Provider? provider;

  Staff({
    required this.id,
    required this.fullName,
    this.bookings,
    this.provider,
    this.services,
  });
}
