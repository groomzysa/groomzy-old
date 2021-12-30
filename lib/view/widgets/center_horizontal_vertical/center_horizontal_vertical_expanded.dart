import 'package:flutter/material.dart';

class AndroidCenterHorizontalVerticalExpanded extends StatelessWidget {
  final Widget screenContent;

  const AndroidCenterHorizontalVerticalExpanded({
    required this.screenContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: screenContent),
      ],
    );
  }
}
