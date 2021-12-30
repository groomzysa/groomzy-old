import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/category.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/rating.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/service_provider_category.dart';
import 'package:groomzy/model/staff.dart';

class Provider {
  final int? id;
  final String? email;
  final String? name;
  final String? phoneNumber;
  final String? tradingName;
  final Address? address;
  final List<Booking>? bookings;
  final List<ServiceProviderCategory>? serviceProviderCategories;
  final List<Staff>? staffs;
  final List<DayTime>? dayTimes;
  final int minimumDuration;
  final List<Category>? categories;
  final List<Service>? services;
  final List<Rating>? ratings;

  Provider({
     this.id,
    this.email,
     this.name,
    this.phoneNumber,
    this.tradingName,
    this.bookings,
    this.dayTimes,
    this.address,
    this.serviceProviderCategories,
    this.staffs,
    this.minimumDuration = -1,
    this.services,
    this.categories,
    this.ratings,
  });
}
