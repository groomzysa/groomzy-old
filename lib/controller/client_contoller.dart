import 'package:get/get.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/staff.dart';
import 'package:groomzy/utils/enums.dart';

class ClientController extends GetxController {
  final Rx<int> _selectedIndex = 0.obs;
  final Rx<int> _clientId = 0.obs;
  final RxList<Booking> _bookings = [
    Booking(
      id: 0,
      bookingTime: DateTime.now(),
      createdAt: DateTime.now(),
      inHouse: false,
      status: BookingStatus.none,
      service: Service(
          id: 0,
          description: '',
          duration: 0.0,
          durationUnit: '',
          price: 0.0,
          title: ''),
      provider: Provider(),
      staff: Staff(id: 0, fullName: ''),
    )
  ].obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int input) => _selectedIndex.value = input;

  int get clientId => _clientId.value;
  set clientId(int input) => _clientId.value = input;

  List<Booking> get bookings => _bookings.value;
  set bookings(List<Booking> input) => _bookings.value = input;
}
