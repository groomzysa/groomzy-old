import 'package:flutter/material.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';

import './widgets/services.dart';
import './widgets/details.dart';
import './widgets/reviews.dart';

class ProviderTrading extends StatelessWidget {
  final int selectedIndex;

  const ProviderTrading({
    required this.selectedIndex,
    Key? key,
  }) : super(key: key);

  List<Widget> _widgetOptions() {
    return <Widget>[
      Services(),
      Details(),
      Reviews(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Map currentDevice = Utils().currentDevice(context);

    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentDevice['isDesktop']) AndroidDrawer(),
            if (currentDevice['isDesktop'])
              const VerticalDivider(),
            Expanded(
              child: Container(
                child: _widgetOptions().elementAt(selectedIndex),
              ),
            ),
          ],
        ));
    return Container(
      child: _widgetOptions().elementAt(selectedIndex),
    );
  }
}
