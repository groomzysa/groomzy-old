import 'package:flutter/material.dart';

class AndroidAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  AndroidAppBar({
    required this.title,
    Key? key,
  })  : preferredSize = const Size.fromHeight(55.0),
        super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0.0,
    );
  }
}
