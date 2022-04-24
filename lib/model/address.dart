import 'package:groomzy/model/client.dart';
import 'package:groomzy/model/provider.dart';

class Address {
  final int? id;
  final String? streetNumber;
  final String? streetName;
  final String? suburbName;
  final String? cityName;
  final String? provinceName;
  final String? areaCode;
  final double? latitude;
  final double? longitude;
  final Client? client;
  final Provider? provider;

  Address({
    this.id,
    this.streetNumber,
    this.streetName,
    this.suburbName,
    this.cityName,
    this.provinceName,
    this.areaCode,
    this.latitude,
    this.longitude,
    this.client,
    this.provider,
  });
}
