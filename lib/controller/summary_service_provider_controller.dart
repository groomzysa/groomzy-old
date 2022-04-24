import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:groomzy/utils/location_service.dart';

class SummaryServiceProviderController extends GetxController {
  final _distanceToProvider = null.obs;
  final Rx<String> _address = '0'.obs;
  final _isLoading = false.obs;
  final _deviceLocation = geolocator.Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
  ).obs;
  final _providerLocation = geocoding.Location(
    latitude: 0,
    longitude: 0,
    timestamp: DateTime.now(),
  ).obs;

  String get address => _address.value;
  set address(String input) => _address.value = input;

  get distanceToProvider => _distanceToProvider.value;
  set distanceToProvider(input) => _distanceToProvider.value = input;

  get isLoading => _isLoading.value;
  set isLoading(input) => _isLoading.value = input;

  get deviceLocation => _deviceLocation.value;
  set deviceLocation(input) => _deviceLocation.value = input;

  get providerLocation => _providerLocation.value;
  set providerLocation(input) => _providerLocation.value = input;

  Future<String?> getDistance(double? latitude, double? longitude, bool hasAddress) async {
    try {
      isLoading = true;
      if (!hasAddress || latitude == null || longitude == null) {
        isLoading = false;
        return null;
      }
      var dPosition = await GeolocationService().determinePosition();
      if (dPosition != null) {
        var distance = (geolocator.Geolocator.distanceBetween(
              dPosition.latitude,
              dPosition.longitude,
              latitude,
              longitude,
            ) /
            1000);
        if (distance > 0) {
          isLoading = false;
          return distance.toStringAsFixed(1);
        }
      }
      isLoading = false;
      return null;
    } catch (error) {
      isLoading = false;
      throw Exception(error);
    }
  }
}
