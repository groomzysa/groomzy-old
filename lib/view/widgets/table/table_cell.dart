import 'package:flutter/material.dart';

class TableValue extends StatelessWidget {
  final String value;
  final Color? textColor;

  const TableValue({
    required this.value,
    this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Text(
        value,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }
}
