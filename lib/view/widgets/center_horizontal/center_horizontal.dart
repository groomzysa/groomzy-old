import 'package:flutter/material.dart';

class AndroidCenterHorizontal extends StatelessWidget {
  final Widget screenContent;

  const AndroidCenterHorizontal({
    required this.screenContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [screenContent],
        ),
      ),
    );
  }
}
