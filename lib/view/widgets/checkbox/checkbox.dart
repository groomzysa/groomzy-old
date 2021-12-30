import 'package:flutter/material.dart';

class AndroidCheckBox extends StatelessWidget {
  final String label;
  final bool checked;
  final void Function(bool?) onChecked;
  final bool textBelow;
  const AndroidCheckBox({
    required this.onChecked,
    required this.label,
    required this.checked,
    this.textBelow = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return textBelow
        ? Column(
            children: [
              Checkbox(
                value: checked,
                onChanged: onChecked,
                checkColor: Colors.white,
                activeColor: Theme.of(context).primaryColor,
              ),
              Text(label),
            ],
          )
        : Row(
            children: [
              Checkbox(
                value: checked,
                onChanged: onChecked,
                checkColor: Colors.white,
                activeColor: Theme.of(context).primaryColor,
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          );
  }
}
