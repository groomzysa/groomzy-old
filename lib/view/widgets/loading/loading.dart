import 'package:flutter/material.dart';

import '../center_horizontal_vertical/center_horizontal_vertical.dart';

class AndroidLoading extends StatelessWidget {
  const AndroidLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AndroidCenterHorizontalVertical(
      screenContent: Column(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          ),
          Text('Loading...'),
        ],
      ),
    );
  }
}
