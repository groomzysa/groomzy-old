import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AndroidSort extends StatelessWidget {
  const AndroidSort({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(
        FontAwesomeIcons.sortAmountDownAlt,
        size: 28,
        color: Colors.grey,
      ),
      onPressed: () {},
    );
  }
}
