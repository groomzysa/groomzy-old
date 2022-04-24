import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groomzy/model/address.dart';
import 'package:groomzy/model/booking.dart';
import 'package:groomzy/model/category.dart';
import 'package:groomzy/model/client.dart';
import 'package:groomzy/model/day.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/rating.dart';
import 'package:groomzy/model/service.dart';
import 'package:groomzy/model/service_provider_category.dart';
import 'package:groomzy/model/staff.dart';
import 'package:groomzy/model/time.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class APIUtils {
  // Store signed in user token
  void setToken(String token) {
    GetStorage().write('token', token);
  }

  // Get currently signed in user
  String? getToken() {
    String? token = GetStorage().read('token');

    return token;
  }

  // Store logged in user
  void setUser(String user) {
    GetStorage().write('user', user);
  }

  // Get currently signed in user
  Map getUser() {
    final storedUser = GetStorage();
    try {
      // Verify the signature in the JWT and extract its claim set
      final decClaimSet = verifyJwtHS256Signature(
        getToken() ?? '',
        dotenv.env['JWT_SECRET'] ?? '',
      );

      if (decClaimSet.expiry != null &&
          DateTime.now().isAfter(decClaimSet.expiry!)) {
        storedUser.write('user', '');
        return {};
      }

      var user = jsonDecode(storedUser.read('user') ?? '');

      return user;
    } catch (e) {
      storedUser.write('user', '');
      return {};
    }
  }

  Provider getProviderProperties(Map provider) {
    var utils = Utils();
    // Provider address
    Map _address = provider['address'];
    Address address = Address(
      id: _address['id'],
      streetNumber: _address['streetNumber'],
      streetName: _address['streetName'],
      suburbName: _address['suburbName'],
      cityName: _address['cityName'],
      provinceName: _address['provinceName'],
      areaCode: _address['areaCode'],
      latitude: _address['latitude'],
      longitude: _address['longitude'],
    );

    // Provider bookings
    List<Booking> bookings = [];
    for (var providerBooking in provider['bookings'] ?? []) {
      // Exclude deleted bookings
      if (providerBooking['status'] != 'Deleted') {
        final bRating = providerBooking['rating'];
        final bService = providerBooking['service'];
        final bClient = providerBooking['client'];
        final bStaff = providerBooking['staff'];

        bookings.add(
          Booking(
            id: providerBooking['id'],
            bookingTime: DateTime.fromMillisecondsSinceEpoch(
                int.parse(providerBooking['bookingTime'])),
            status: Utils().mapBookingStatus(providerBooking['status']),
            rating: bRating != null
                ? Rating(
                    id: bRating['id'],
                    rate: double.parse(bRating['rate'].toString()),
                    comment: bRating['comment'],
                  )
                : null,
            service: Service(
              id: bService['id'],
              title: bService['title'],
              price: double.parse(bService['price'].toString()),
              duration: double.parse(bService['duration'].toString()),
              durationUnit: bService['durationUnit'],
              inHouse: bService['inHouse'],
              description: bService['description'],
            ),
            client: Client(
                id: bClient['id'],
                fullName: bClient['fullName'],
                email: bClient['email'],
                phoneNumber: bClient['phoneNumber']),
            staff: Staff(
              id: bStaff['id'],
              fullName: bStaff['fullName'],
            ),
            inHouse: providerBooking['inHouse'],
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              int.parse(providerBooking['createdAt']),
            ),
          ),
        );
      }
    }

    // Provider business operating day times
    List<DayTime> dayTimes = [];
    for (var dT in provider['dayTimes'] ?? []) {
      dayTimes.add(
        DayTime(
          id: dT['id'],
          day: Day(
            id: dT['day']['id'],
            day: utils.mapDay(dT['day']['day']),
          ),
          time: Time(
            id: dT['time']['id'],
            startTime: dT['time']['startTime'],
            endTime: dT['time']['endTime'],
          ),
        ),
      );
    }

    // Provider services categories
    List<ServiceProviderCategory> serviceProviderCategories = [];
    for (var sPC in provider['serviceProviderCategories'] ?? []) {
      serviceProviderCategories.add(
        ServiceProviderCategory(
          category: Category(
            id: sPC['category']['id'],
            category: sPC['category']['category'],
          ),
          service: Service(
            id: sPC['service']['id'],
            description: sPC['service']['description'],
            duration: double.parse(sPC['service']['duration'].toString()),
            durationUnit: sPC['service']['durationUnit'],
            inHouse: sPC['service']['inHouse'],
            price: double.parse(sPC['service']['price'].toString()),
            title: sPC['service']['title'],
          ),
        ),
      );
    }

    // Provider staffs
    List<Staff> staffs = [];
    for (var s in provider['staffs'] ?? []) {
      staffs.add(Staff(
        id: s['id'],
        fullName: s['fullName'],
      ));
    }

    // Provider categories
    List<Category> categories = [];
    // Provider services
    List<Service> services = [];
    // Provider ratings
    List<Rating> ratings = [];

    if (serviceProviderCategories.isNotEmpty) {
      for (var sPC in serviceProviderCategories) {
        if (!categories.contains(sPC.category)) {
          categories.add(sPC.category!);
        }
        services.add(sPC.service!);
      }
    }

    if (bookings.isNotEmpty) {
      for (var b in bookings) {
        if (b.rating != null) {
          ratings.add(b.rating!);
        }
      }
    }

    // Calculate the minimum booking time gaps
    int minimumDuration = -1;
    for (var service in services) {
      bool isHours = service.durationUnit == 'hrz';
      int duration = 0;
      if (isHours) {
        duration = (service.duration * 60).toInt();
      } else {
        duration = service.duration.toInt();
      }

      if (minimumDuration == -1) {
        minimumDuration = duration;
      } else if (duration < minimumDuration) {
        minimumDuration = duration;
      }

      // else if ((duration - minimumDuration).abs() < minimumDuration ) {
      //   minimumDuration = (duration - minimumDuration).abs();
      // }
    }

    return Provider(
      id: provider['id'],
      fullName: provider['fullName'],
      address: address,
      bookings: bookings,
      categories: categories,
      services: services,
      ratings: ratings,
      staffs: staffs,
      dayTimes: dayTimes,
      minimumDuration: minimumDuration,
    );
  }

  List<ServiceProviderCategory> formatServiceProviderCategory(
      List providerServices) {
    // Provider services categories
    List<ServiceProviderCategory> serviceProviderCategories = [];
    for (var sPC in providerServices) {
      serviceProviderCategories.add(
        ServiceProviderCategory(
          category: Category(
            id: sPC['category']['id'],
            category: sPC['category']['category'],
          ),
          service: Service(
            id: sPC['service']['id'],
            description: sPC['service']['description'],
            duration: double.parse(sPC['service']['duration'].toString()),
            durationUnit: sPC['service']['durationUnit'],
            inHouse: sPC['service']['inHouse'],
            price: double.parse(sPC['service']['price'].toString()),
            title: sPC['service']['title'],
          ),
        ),
      );
    }

    return serviceProviderCategories;
  }

  List<DayTime> formatProviderOperatingTimes(List providerDayTimes) {
    // Provider business operating day times
    List<DayTime> dayTimes = [];
    for (var dT in providerDayTimes) {
      dayTimes.add(
        DayTime(
          id: dT['id'],
          day: Day(
            id: dT['day']['id'],
            day: Utils().mapDay(dT['day']['day']),
          ),
          time: Time(
            id: dT['time']['id'],
            startTime: dT['time']['startTime'],
            endTime: dT['time']['endTime'],
          ),
        ),
      );
    }

    return dayTimes;
  }

  List<Staff> formatProviderStaffs(List providerStaffs) {
    List<Staff> staffs = [];
    for (var staff in providerStaffs) {
      staffs.add(Staff(id: staff['id'], fullName: staff['fullName']));
    }

    return staffs;
  }

  List<Booking> formatProviderBookings(List providerBookings) {
    List<Booking> bookings = [];
    for (var providerBooking in providerBookings) {
      // Exclude deleted bookings
      if (providerBooking['status'] != 'Deleted') {
        final bRating = providerBooking['rating'];
        final bService = providerBooking['service'];
        final bClient = providerBooking['client'];
        final bStaff = providerBooking['staff'];

        bookings.add(
          Booking(
            id: providerBooking['id'],
            bookingTime: DateTime.fromMillisecondsSinceEpoch(
                int.parse(providerBooking['bookingTime'])),
            status: Utils().mapBookingStatus(providerBooking['status']),
            rating: bRating != null
                ? Rating(
                    id: bRating['id'],
                    rate: bRating['rate'],
                    comment: bRating['comment'],
                  )
                : null,
            service: Service(
              id: bService['id'],
              title: bService['title'],
              price: double.parse(bService['price'].toString()),
              duration: double.parse(bService['duration'].toString()),
              durationUnit: bService['durationUnit'],
              inHouse: bService['inHouse'],
              description: bService['description'],
            ),
            client: Client(
                id: bClient['id'],
                fullName: bClient['fullName'],
                email: bClient['email'],
                phoneNumber: bClient['phoneNumber']),
            staff: Staff(
              id: bStaff['id'],
              fullName: bStaff['fullName'],
            ),
            inHouse: providerBooking['inHouse'],
            createdAt: DateTime.fromMillisecondsSinceEpoch(
                int.parse(providerBooking['createdAt'])),
          ),
        );
      }
    }

    return bookings;
  }

  List<Booking> formatClientBookings(List providerBookings) {
    List<Booking> bookings = [];
    for (var providerBooking in providerBookings) {
      // Exclude deleted bookings
      if (providerBooking['status'] != 'Deleted') {
        final bRating = providerBooking['rating'];
        final bService = providerBooking['service'];
        final bProvider = providerBooking['provider'];
        final bStaff = providerBooking['staff'];

        bookings.add(
          Booking(
            id: providerBooking['id'],
            bookingTime: DateTime.fromMillisecondsSinceEpoch(
                int.parse(providerBooking['bookingTime'])),
            status: Utils().mapBookingStatus(providerBooking['status']),
            rating: bRating != null
                ? Rating(
                    id: bRating['id'],
                    rate: double.parse(bRating['rate'].toString()),
                    comment: bRating['comment'],
                  )
                : null,
            service: Service(
              id: bService['id'],
              title: bService['title'],
              price: double.parse(bService['price'].toString()),
              duration: double.parse(bService['duration'].toString()),
              durationUnit: bService['durationUnit'],
              inHouse: bService['inHouse'],
              description: bService['description'],
            ),
            provider: Provider(
              id: bProvider['id'],
              fullName: bProvider['fullName'],
            ),
            staff: Staff(
              id: bStaff['id'],
              fullName: bStaff['fullName'],
            ),
            inHouse: providerBooking['inHouse'],
            createdAt: DateTime.fromMillisecondsSinceEpoch(
                int.parse(providerBooking['createdAt'])),
          ),
        );
      }
    }

    return bookings;
  }
}
