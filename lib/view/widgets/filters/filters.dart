import 'package:flutter/material.dart';

class AndroidFilters extends StatelessWidget {
  const AndroidFilters({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.filter_list_outlined,
        size: 38.0,
        color: Colors.grey,
      ),
      onPressed: () {},
    );
  }
}
