import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/client/book.dart';
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
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/checkbox/checkbox.dart';
import 'package:groomzy/view/widgets/heading/heading.dart';
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
    Future<void> _submit(
        {MultiSourceResult Function(Map<String, dynamic>,
                {Object? optimisticResult})?
            clientBook}) async {
      clientBook!({
        'providerId': providerController.provider.id,
        'serviceId': providerTradingController.selectedService.id,
        'staffId': bookController.selectedStafferId,
        'bookingDate':
            DateFormat('yyyy-MM-dd').format(bookController.selectedDay),
        'bookingTime':  bookController.selectedTime,
        'inHouse': bookController.inHouse,
        'address': bookController.serviceCallAddress,
      });
    }

    return Obx(() {
      service_model.Service selectedService =
          providerTradingController.selectedService;
      Provider provider = providerController.provider;
      List<DayTime> dayTimes = provider.dayTimes!;

      return Mutation(
        options: MutationOptions(
          document: gql(ClientBookMutation().clientBook),
          update: (
            GraphQLDataProxy? cache,
            QueryResult? result,
          ) {
            if (result!.hasException) {
              String errMessage = result.exception!.graphqlErrors[0].message;
              Get.defaultDialog(
                title: 'Oops!',
                titleStyle: TextStyle(color: Theme.of(context).primaryColor),
                contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                content: Text(
                  errMessage,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 18.0,
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    onPressed: () {
                      Get.toNamed(SignInScreen.routeName);
                    },
                  )
                ],
              );
            }
          },
          onCompleted: (dynamic clientBookResult) async {
            if (clientBookResult != null) {
              Map booking = clientBookResult['clientBook'];
              if (booking.isNotEmpty && booking['id'] != null) {
                // Go to the checkout screen
                Get.toNamed(
                  CheckoutScreen.routeName,
                  arguments: {
                    'bookingId': booking['id'],
                    'serviceId': selectedService.id,
                    'name': selectedService.title,
                    'description': selectedService.description,
                    'price': selectedService.price,
                  },
                );
              }
            }
          },
        ),
        builder: (
          RunMutation? runBookMutation,
          QueryResult? bookResult,
        ) {
          return Obx(() {
            return Container(
              margin: const EdgeInsets.all(
                10.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingOperationalDays(dayTimes: dayTimes),
                  const Divider(
                    height: 20.0,
                  ),
                  const AndroidHeading(title: 'Select date'),
                  const Divider(),
                  Text(
                    'Selected date: ${DateFormat.yMEd().format(bookController.selectedDay)}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  BookingCalendar(
                    dayTimes: dayTimes,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        height: 20.0,
                      ),
                      const AndroidHeading(title: 'Select time'),
                      const Divider(),
                      if ( bookController.selectedTime != 'none')
                        Text(
                          'Selected time: ${ bookController.selectedTime} hrz',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      BookingTimes(
                        selectTime: (time) {
                          bookController.selectedTime = time;
                          bookController.selectedStaffer = 'none';
                        },
                        dayTimes: dayTimes,
                        selectedDay: bookController.selectedDay,
                        selectedTime:  bookController.selectedTime,
                        minimumDuration: provider.minimumDuration,
                        bookings: provider.bookings ?? [],
                        duration: selectedService.duration!.toInt(),
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
                  if (bookController.inHouse &&
                      Utils().canSelectTime(
                        selectedDay: bookController.selectedDay,
                        dayTimes: dayTimes,
                      ))
                    Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        const AndroidHeading(title: 'Enter address'),
                        AndroidTextField(
                          prefixIcon: Icons.location_on_outlined,
                          label: 'Address',
                          onInputChange: (input) {
                            bookController.serviceCallAddress = input;
                          },
                        ),
                      ],
                    ),
                  if (Utils().canSelectStaff(
                        inHouse: bookController.inHouse,
                        serviceCallAddress: bookController.serviceCallAddress,
                        selectedTime:  bookController.selectedTime,
                      ) &&
                      Utils().canSelectTime(
                        selectedDay: bookController.selectedDay,
                        dayTimes: dayTimes,
                      ))
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          height: 20.0,
                        ),
                        const AndroidHeading(title: 'Select staffer'),
                        const Divider(),
                        if (bookController.selectedStaffer != 'none')
                          Text(
                            'Selected staffer: ${bookController.selectedStaffer}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        BookingStaffs(
                          staffs: provider.staffs ?? [],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  if (Utils().canBook(
                          inHouse: bookController.inHouse,
                          serviceCallAddress: bookController.serviceCallAddress,
                          selectedTime:  bookController.selectedTime,
                          selectedStaffer: bookController.selectedStaffer) &&
                      Utils().canSelectTime(
                        selectedDay: bookController.selectedDay,
                        dayTimes: dayTimes,
                      ))
                    AndroidButton(
                      label: 'Checkout',
                      backgroundColor: Theme.of(context).primaryColor,
                      pressed: () async {
                        _submit(clientBook: runBookMutation);
                      },
                    ),
                ],
              ),
            );
          });
        },
      );
    });
  }
}
