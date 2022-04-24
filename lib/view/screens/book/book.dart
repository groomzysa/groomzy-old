import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/mutations/client/book_mutation.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/provider_trading_controller.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/model/provider.dart';
import 'package:groomzy/model/service.dart' as service_model;
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/book/widgets/booking_calendar.dart';
import 'package:groomzy/view/screens/book/widgets/booking_operational_days.dart';
import 'package:groomzy/view/screens/book/widgets/booking_staffs.dart';
import 'package:groomzy/view/screens/book/widgets/booking_times.dart';
import 'package:groomzy/view/screens/checkout/main.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';
import 'package:intl/intl.dart';

class Book extends StatelessWidget {
  Book({
    Key? key,
  }) : super(key: key);

  final BookController bookController = Get.find();
  final ProviderController providerController = Get.find();
  final ProviderTradingController providerTradingController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future<void> _submit() async {
      try {
        Map<String, dynamic> response =
            await ClientBookMutation().clientBookMutation();
        if (response['status']!) {
          bookController.id = response['bookingId'];
          Get.toNamed(CheckoutScreen.routeName);
        }
      } catch (err) {
        if (err.toString().contains('sign')) {
          Get.defaultDialog(
            title: 'Oops!',
            titleStyle: TextStyle(color: Theme.of(context).primaryColor),
            contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
            content: Text(
              '$err',
            ),
            radius: 0,
            actions: [
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                onPressed: () {
                  Get.toNamed(SignInScreen.routeName);
                },
              )
            ],
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AndroidAlertDialog(
                title: 'Oops!',
                message: Text(
                  '$err',
                ),
              );
            },
          );
        }
      }
    }

    return Obx(() {
      if (bookController.isLoading) {
        return const AndroidLoading();
      }

      service_model.Service selectedService =
          providerTradingController.selectedService;
      Provider provider = providerController.provider;
      List<DayTime> dayTimes = provider.dayTimes!;

      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(
            5.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingOperationalDays(dayTimes: dayTimes),
              const Divider(),
              Text(
                'Selected date: ${DateFormat.yMEd().format(bookController.selectedDay)}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              BookingCalendar(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    bookController.selectedTime != 'none'
                        ? 'Selected time: ${bookController.selectedTime} hrz'
                        : 'Select time: ',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  BookingTimes(
                    minimumDuration: provider.minimumDuration,
                    bookings: provider.bookings ?? [],
                    duration: selectedService.duration.toInt(),
                  ),
                ],
              ),
              /* This will be done post MVP */
              // if ( bookController.selectedTime != 'none' &&
              //     Utils().canSelectTime(
              //       selectedDay: bookController.selectedDay,
              //       dayTimes: dayTimes,
              //     ))
              //   Column(
              //     children: [
              //       const Divider(
              //         height: 20.0,
              //       ),
              //       AndroidCheckBox(
              //         label: 'Is this an in house service call?',
              //         checked: bookController.inHouse,
              //         onChecked: (check) {
              //           bookController.inHouse = check!;
              //           bookController.serviceCallAddress = 'none';
              //           bookController.selectedStaffer = 'none';
              //         },
              //       ),
              //     ],
              //   ),
              if (bookController.inHouse && Utils().canSelectTime())
                Column(
                  children: [
                    AndroidTextField(
                      prefixIcon: Icons.location_on_outlined,
                      label: 'Enter full Address',
                      onInputChange: (input) {
                        bookController.serviceCallAddress = input;
                      },
                    ),
                  ],
                ),
              if (Utils().canSelectStaff() &&
                  Utils().canSelectTime())
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      bookController.selectedStaffer != 'none'
                          ? 'Selected staffer: ${bookController.selectedStaffer}'
                          : 'Select staffer: ',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    BookingStaffs(
                      staffs: provider.staffs ?? [],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              if (Utils().canBook() && Utils().canSelectTime())
                AndroidButton(
                  label: 'Checkout',
                  backgroundColor: Theme.of(context).primaryColor,
                  pressed: () async {
                    _submit();
                  },
                ),
            ],
          ),
        ),
      );
    });
  }
}
