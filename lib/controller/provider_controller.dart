import 'package:get/get.dart';
import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/client.dart';
import 'package:groomzy/model/day.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/service_provider_category.dart';
import 'package:groomzy/model/staff.dart';
import 'package:groomzy/model/time.dart';
import 'package:groomzy/utils/enums.dart';

class ProviderController extends GetxController {
  final Rx<int> _selectedIndex = 0.obs;
  final Rx<int> _providerId = 0.obs;
  final Rx<Provider> _provider = Provider().obs;
  final RxList<Provider> _providers = [Provider()].obs;
  final RxList<ServiceProviderCategory> _providerServices = [
    ServiceProviderCategory(),
  ].obs;
  final RxList<DayTime> _operatingTimes = [
    DayTime(
      id: 0,
      day: Day(id: 0, day: BusinessDay.none, dayTimes: []),
      time: Time(id: 0, startTime: '', endTime: ''),
      provider: Provider(),
    ),
  ].obs;
  final RxList<Staff> _staffs = [Staff(id: 0, fullName: '')].obs;
  final RxList<Booking> _bookings = [
    Booking(
      id: 0,
      client: Client(id: 0, fullName: '', address: Address(), email: '', phoneNumber: '', bookings: []),
      bookingTime: DateTime.now(),
      createdAt: DateTime.now(),
      inHouse: false,
      service: Service(id: 0, description: '', duration: 0.0, durationUnit: '', title: '', price: 0.0),
      staff: Staff(id: 0,fullName: ''),
      status: BookingStatus.none,
    )
  ].obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int input) => _selectedIndex.value = input;

  int get providerId => _providerId.value;
  set providerId(int input) => _providerId.value = input;

  Provider get provider => _provider.value;
  set provider(Provider input) => _provider.value = input;

  List<Provider> get providers => _providers.value;
  set providers(List<Provider> input) => _providers.value = input;

  List<ServiceProviderCategory> get providerServices => _providerServices.value;
  set providerServices(List<ServiceProviderCategory> input) =>
      _providerServices.value = input;

  List<DayTime> get operatingTimes => _operatingTimes.value;
  set operatingTimes(List<DayTime> dt) => _operatingTimes.value = dt;

  List<Staff> get staffs => _staffs.value;
  set staffs(List<Staff> input) => _staffs.value = input;

  List<Booking> get bookings => _bookings.value;
  set bookings(List<Booking> input) => _bookings.value = input;
}
