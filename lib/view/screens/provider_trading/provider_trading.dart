import 'package:flutter/material.dart';

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
      const Services(),
      Details(),
      const Reviews(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _widgetOptions().elementAt(selectedIndex),
    );
  }
}
