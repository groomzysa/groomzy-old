import 'package:flutter/material.dart';

class AndroidTextField extends StatelessWidget {
  final String? label;
  final String value;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double borderRadius;
  final Color labelColor;
  final Color borderColor;
  final Color suffixIconColor;
  final Color prefixIconColor;
  final Color cursorColor;
  final bool obscureText;
  final void Function(String)? onInputChange;
  final String? Function(String?)? onValidation;
  final bool enabled;
  final void Function()? suffixIconAction;
  final int maxLines;

  const AndroidTextField({
    this.label,
    this.value = '',
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius = 0,
    this.borderColor = Colors.grey,
    this.labelColor = Colors.grey,
    this.suffixIconColor = Colors.grey,
    this.prefixIconColor = Colors.grey,
    this.cursorColor =  Colors.grey,
    this.onInputChange,
    this.onValidation,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIconAction,
    this.maxLines = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      obscureText: obscureText,
      onChanged: onInputChange,
      validator: onValidation,
      cursorColor: cursorColor,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        labelStyle: TextStyle(
          color: labelColor,
        ),
        labelText: label,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: prefixIconColor,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(child: Icon(
          suffixIcon,
          color: suffixIconColor,
        ), onTap: suffixIconAction,)
            : null,
      ),
    );
  }
}
