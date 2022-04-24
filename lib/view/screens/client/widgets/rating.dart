import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/model/booking.dart' as booking_model;
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/view/widgets/button/button.dart';
import 'package:groomzy/view/widgets/heading/heading.dart';
import 'package:groomzy/view/widgets/rating/rating.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class Rating extends StatelessWidget {
  final booking_model.Booking booking;
  final Future<void> Function() submit;
  Rating({
    Key? key,
    required this.booking,
    required this.submit,
  }) : super(key: key);

  final BookController bookController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        constraints: const BoxConstraints(
          maxHeight: 500.0,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AndroidHeading(
                    title: 'Rating',
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      FontAwesomeIcons.times,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10.0),
              AndroidRating(
                ratingCounts: booking.rating?.rate ?? 0,
                onRatingUpdate: (rating) {
                  bookController.rating = rating;
                },
                itemSize: 40,
                icon: Icons.star_outline,
                iconColor: Colors.lightGreen,
              ),
              const SizedBox(height: 10.0),
              AndroidTextField(
                value: bookController.comment.isNotEmpty
                    ? bookController.comment
                    : booking.rating?.comment ?? '',
                label: 'comment',
                prefixIcon: Icons.comment_outlined,
                onInputChange: (input) {
                  bookController.comment = input;
                },
                maxLines: 4,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: AndroidButton(
                      label: 'Rate',
                      fontSize: 16,
                      backgroundColor: Colors.lightGreen,
                      pressed: () {
                        if ([BookingStatus.done, BookingStatus.cancelled]
                            .contains(booking.status)) {
                          bookController.id = booking.id;
                          bookController.ratingId = booking.rating?.id ?? 0;
                          bookController.rate = true;
                          submit();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: AndroidButton(
                      label: 'Cancel',
                      fontSize: 16,
                      backgroundColor: Theme.of(context).primaryColor,
                      pressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
