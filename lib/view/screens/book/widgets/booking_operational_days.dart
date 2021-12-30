import 'package:flutter/material.dart';
import 'package:groomzy/model/day_time.dart';
import 'package:groomzy/utils/utils.dart';

class BookingOperationalDays extends StatelessWidget {
  final List<DayTime> dayTimes;

  const BookingOperationalDays({required this.dayTimes, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List weekDays = Utils().weekDays();
    dayTimes.sort(
      (a, b) =>
          weekDays.indexOf(a.day) - weekDays.indexOf(b.day),
    );

    return Row(
      children: [
        const SizedBox(
          width: 110.0,
          child: Text(
            'Operating days:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...dayTimes
                  .map(
                    (dayTime) => Text(
                      Utils().mapDayToString(dayTime.day.day),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        )
      ],
    );
  }
}
