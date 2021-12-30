import 'package:groomzy/model/client.dart';
import 'package:groomzy/model/provider.dart';

class Address {
  final int? id;
  final String? address;
  final double? latitude;
  final double? longitude;
  final Client? client;
  final Provider? provider;

  Address({
    this.id,
    this.address,
    this.latitude,
    this.longitude,
    this.client,
    this.provider,
  });
}
