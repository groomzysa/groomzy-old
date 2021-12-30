import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/service_provider_category.dart';
import 'package:groomzy/model/staff.dart';

class User {
  final int? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? tradingName;
  final String? role;
  final Address? address;
  final List<Booking?>? bookings;
  final List<ServiceProviderCategory?>? serviceProviderCategories;
  final List<Staff?>? staffs;
  final List<DayTime?>? dayTimes;

  User({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.tradingName,
    this.role,
    this.bookings,
    this.dayTimes,
    this.address,
    this.serviceProviderCategories,
    this.staffs,
  });
}
