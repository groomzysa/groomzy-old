import 'package:groomzy/model/client.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/rating.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/staff.dart';
import 'package:groomzy/model/transport_cost.dart';
import 'package:groomzy/utils/enums.dart';

class Booking {
  final int? id;
  final DateTime? bookingTime;
  final DateTime? createdAt;
  final bool? inHouse;
  final BookingStatus? status;
  final Client? client;
  final Rating? rating;
  final Provider? provider;
  final Staff? staff;
  final Service? service;
  final TransportCost? transportCost;

  Booking({
    this.id,
    this.bookingTime,
    this.createdAt,
    this.inHouse,
    this.status,
    this.provider,
    this.service,
    this.client,
    this.rating,
    this.staff,
    this.transportCost,
  });
}
