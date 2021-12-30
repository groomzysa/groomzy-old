import 'package:flutter/material.dart';
import 'package:groomzy/view/screens/provider/widgets/bookings/bookings.dart';
import 'package:groomzy/view/screens/provider/widgets/operating_times/operating_times.dart';
import 'package:groomzy/view/screens/provider/widgets/services/services.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/staffs.dart';
import 'package:groomzy/view/widgets/center_horizontal/center_horizontal_expanded.dart';

class Provider extends StatelessWidget {
  final int selectedIndex;
  final int providerId;

  const Provider({
    required this.selectedIndex,
    required this.providerId,
    Key? key,
  }) : super(key: key);

  List<Widget> _widgetOptions() {
    return <Widget>[
      AndroidCenterHorizontalExpanded(
        screenContent: Services(
          providerId: providerId,
        ),
      ),
      AndroidCenterHorizontalExpanded(
        screenContent: Bookings(
          providerId: providerId,
        ),
      ),
      AndroidCenterHorizontalExpanded(
        screenContent: Staffs(
          providerId: providerId,
        ),
      ),
      AndroidCenterHorizontalExpanded(
          screenContent: OperatingTimes(
        providerId: providerId,
      )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _widgetOptions().elementAt(selectedIndex),
    );
  }
}
