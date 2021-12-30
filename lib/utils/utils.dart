import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/rating.dart';
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/view/screens/client/main.dart';
import 'package:groomzy/view/screens/explorer/main.dart';
import 'package:groomzy/view/screens/provider/main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  String twoDigitWholeNumber(int number) {
    return number.abs() < 10 ? '0$number' : number.toString();
  }

  String graphQLError(String errorMessage) {
    return errorMessage
        .replaceAll('GraphQL Errors:', '')
        .replaceAll(': Undefined location', '')
        .replaceAll('Network Errors:', '');
  }

  Future<void> setFirstTimeAppLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstTime', 'No');
  }

  Future<String?> getFirstTimeAppLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstTime = prefs.getString('firstTime');
    return firstTime;
  }

  String serviceTypeDescription(String serviceType, bool split) {
    String type = '';
    if (serviceType == 'Barber') {
      type = 'barber';
    }
    if (serviceType == 'Hairdresser') {
      type = split ? 'hair\ndresser' : 'hairdresser';
    }
    if (serviceType == 'Makeup artist') {
      type = split ? 'makeup\nartist' : 'makeup artist';
    }
    if (serviceType == 'Massage') {
      type = 'masseur';
    }
    if (serviceType == 'Nail technician') {
      type = split ? 'nail\ntechnicians' : 'nail technicians';
    }
    if (serviceType == 'Spa') {
      type = 'spa';
    }

    return type;
  }

  String serviceTypeImagePath(String serviceType) {
    String imagePath = '';
    if (serviceType == 'Barber') {
      imagePath = 'assets/images/barber.png';
    }
    if (serviceType == 'Hairdresser') {
      imagePath = 'assets/images/hairdresser.png';
    }
    if (serviceType == 'Makeup artist') {
      imagePath = 'assets/images/makeup_artist.png';
    }
    if (serviceType == 'Massage') {
      imagePath = 'assets/images/spa.png';
    }
    if (serviceType == 'Nail technician') {
      imagePath = 'assets/images/nail_technician.png';
    }
    if (serviceType == 'Spa') {
      imagePath = 'assets/images/spa.png';
    }

    return imagePath;
  }

  Map<String, dynamic> providerRating(List<Rating>? ratings) {
    double ratingPercentage;
    double ratingCounts;
    String ratingStatus;

    if (ratings != null && ratings.isEmpty) {
      return {
        'rating': '#',
        'ratingStatus': 'Not yet rated',
      };
    }

    double totalRating =
        ratings!.fold(0, (total, rating) {
      return total += rating.rate;
    });
    ratingPercentage = totalRating / (5 * ratings.length) * 100;
    ratingCounts = (totalRating / (5 * ratings.length)) * 5;

    if (ratingPercentage >= 70) {
      ratingStatus = 'Superb';
    } else if (ratingPercentage >= 50) {
      ratingStatus = 'Fair';
    } else {
      ratingStatus = 'Poor';
    }

    Map _ratingReview = ratingReview(ratingCounts);

    return {
      'ratingPercentage': ratingPercentage.toStringAsFixed(2),
      'ratingCounts': ratingCounts,
      'ratingStatus': ratingStatus,
      'ratingIcon': _ratingReview['icon'],
      'ratingColor': _ratingReview['color'],
    };
  }

  Map ratingReview(rating) {
    if (rating >= 3.5) {
      return {
        "icon": FontAwesomeIcons.grinStars,
        "color": Colors.green,
      };
    } else if (rating >= 2.5) {
      return {
        "icon": FontAwesomeIcons.smile,
        "color": Colors.amber,
      };
    }
    return {
      "icon": FontAwesomeIcons.frown,
      "color": Colors.red,
    };
  }

  Future<void> setBookingMadePayloadId(int barberBookingMadePayloadId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'barberBookingMadePayloadId', barberBookingMadePayloadId);
  }

  Future<int?> getBookingMadePayloadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? barberBookingMadePayloadId =
        prefs.getInt('barberBookingMadePayloadId');

    return barberBookingMadePayloadId;
  }

  Future<void> setHairdresserBookingMadePayloadId(
      int hairdresserBookingMadePayloadId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'hairdresserBookingMadePayloadId', hairdresserBookingMadePayloadId);
  }

  Future<int?> getHairdresserBookingMadePayloadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? hairdresserBookingMadePayloadId =
        prefs.getInt('hairdresserBookingMadePayloadId');

    return hairdresserBookingMadePayloadId;
  }

  Future<void> setMakeupArtistBookingMadePayloadId(
      int makeupArtistBookingMadePayloadId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'makeupArtistBookingMadePayloadId', makeupArtistBookingMadePayloadId);
  }

  Future<int?> getMakeupArtistBookingMadePayloadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? makeupArtistBookingMadePayloadId =
        prefs.getInt('makeupArtistBookingMadePayloadId');

    return makeupArtistBookingMadePayloadId;
  }

  Future<void> setNailTechnicianBookingMadePayloadId(
      int nailTechnicianBookingMadePayloadId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nailTechnicianBookingMadePayloadId',
        nailTechnicianBookingMadePayloadId);
  }

  Future<int?> getNailTechnicianBookingMadePayloadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? nailTechnicianBookingMadePayloadId =
        prefs.getInt('nailTechnicianBookingMadePayloadId');

    return nailTechnicianBookingMadePayloadId;
  }

  List<String> weekDays() {
    return [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
  }

  List<String> categories() {
    return [
      'Barber',
      'Hairdresser',
      'Makeup artist',
      'Nail technician',
      'Spa',
    ];
  }

  Future<Widget> getImage(String url) async {
    final Completer<Widget> completer = Completer();
    final image = NetworkImage(url);

    final load = image.resolve(const ImageConfiguration());

    final listener = ImageStreamListener((ImageInfo info, isSync) async {
      if (info.image.width == 80 && info.image.height == 160) {
        completer.complete(const Text('AZAZA'));
      } else {
        completer.complete(Image(image: image));
      }
    });

    load.addListener(listener);
    return completer.future;
  }

  // Store explorer search
  Future<void> setExplorerSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('explorer_search', search);
  }

  // Get explorer search
  Future<String?> getExplorerSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? explorerSearch = prefs.getString('explorer_search');

    return explorerSearch;
  }

  bool canBook({
    bool inHouse = false,
    required String serviceCallAddress,
    required String selectedTime,
    required String selectedStaffer,
  }) {
    return (inHouse &&
            serviceCallAddress != 'none' &&
            selectedTime != 'none' &&
            selectedStaffer != 'none') ||
        (!inHouse &&
            serviceCallAddress == 'none' &&
            selectedTime != 'none' &&
            selectedStaffer != 'none');
  }

  bool canSelectTime({
    DateTime? selectedDay,
    required List<DayTime> dayTimes,
  }) {
    String day = selectedDay != null
        ? DateFormat.yMEd().add_jms().format(selectedDay).split(',')[0]
        : '';
    List activeDays =
        dayTimes.where((dayTime) => mapDayToString(dayTime.day.day) == day).toList();
    return activeDays.isNotEmpty;
  }

  bool canSelectStaff({
    bool inHouse = false,
    String? serviceCallAddress,
    String? selectedTime,
  }) {
    return (inHouse && serviceCallAddress != 'none' && selectedTime != 'none') ||
        (!inHouse && serviceCallAddress == 'none' && selectedTime != 'none');
  }

  Color bookingStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.active:
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.deleted:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  homeScreen(String role) {
    if (role == 'Client') {
      return ClientScreen();
    } else if (role == 'Provider') {
      return ProviderScreen();
    }
    return ExploreScreen();
  }

  String navigateToHome(String role) {
    if (role == 'Client') {
      return ClientScreen.routeName;
    } else if (role == 'Provider') {
      return ProviderScreen.routeName;
    }
    return ExploreScreen.routeName;
  }

  BookingStatus mapBookingStatus(String status){
    switch (status) {
      case 'Active':
        return BookingStatus.active;
      case 'Pending':
        return BookingStatus.pending;
      case 'Cancelled':
        return BookingStatus.cancelled;
      case 'Deleted':
        return BookingStatus.deleted;
      case 'Done':
        return BookingStatus.done;
      default:
        return BookingStatus.none;
    }
  }

  String mapBookingStatusToString(BookingStatus status){
    switch (status) {
      case BookingStatus.active:
        return 'Active';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.deleted:
        return 'Deleted';
      case BookingStatus.done:
        return 'Done';
      default:
        return 'None';
    }
  }

  BusinessDay mapDay(String day){
    switch (day) {
      case 'Mon':
        return BusinessDay.mon;
      case 'Tue':
        return BusinessDay.tue;
      case 'Wed':
        return BusinessDay.wed;
      case 'Thu':
        return BusinessDay.thu;
      case 'Fri':
        return BusinessDay.fri;
      case 'Sat':
        return BusinessDay.sat;
      case 'Sun':
        return BusinessDay.sun;
      default:
        return BusinessDay.none;
    }
  }

  String mapDayToString(BusinessDay day){
    switch (day) {
      case BusinessDay.mon :
        return 'Mon';
      case BusinessDay.tue :
        return 'Tue';
      case BusinessDay.wed :
        return 'Wed';
      case BusinessDay.thu :
        return 'Thu';
      case BusinessDay.fri :
        return 'Fri';
      case BusinessDay.sat :
        return 'Sat';
      case BusinessDay.sun :
        return 'Sun';
      default:
        return '';
    }
  }
}
