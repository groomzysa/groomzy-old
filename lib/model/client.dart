import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/booking.dart';

class Client {
  final int id;
  final String email;
  final String fullName;
  final String phoneNumber;
  final Address address;
  final List<Booking> bookings;

  Client({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.bookings,
    required this.address,
  });
}
