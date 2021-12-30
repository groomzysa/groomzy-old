import 'package:flutter/material.dart';

class AndroidCenterHorizontalExpanded extends StatelessWidget {
  final Widget screenContent;

  const AndroidCenterHorizontalExpanded({
    required this.screenContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: screenContent),
      ],
    );
  }
}
