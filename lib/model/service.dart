import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/service_provider_category.dart';
import 'package:groomzy/model/staff.dart';

class Service {
  final int? id;
  final String? description;
  final double? duration;
  final String? durationUnit;
  final bool? inHouse;
  final double? price;
  final String? title;
  final List<ServiceProviderCategory?>? serviceProviderCategories;
  final List<Booking?>? bookings;
  final List<Staff?>? staffs;

  Service({
    this.id,
    this.inHouse,
    this.description,
    this.duration,
    this.durationUnit,
    this.price,
    this.title,
    this.staffs,
    this.serviceProviderCategories,
    this.bookings,
  });
}
