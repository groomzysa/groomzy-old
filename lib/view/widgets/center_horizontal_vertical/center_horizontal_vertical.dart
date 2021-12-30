import 'package:flutter/material.dart';

class AndroidCenterHorizontalVertical extends StatelessWidget {
  final Widget screenContent;

  const AndroidCenterHorizontalVertical({
    required this.screenContent,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: screenContent,
            )
          ],
        ),
      ),
    );
  }
}
