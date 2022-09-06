import 'package:flutter/material.dart';

class LabelButton extends StatelessWidget {
  final String labelText;
  final void Function() onPressed;

  /// botón plano con texto
  const LabelButton(
      {Key? key, required this.labelText, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        labelText,
      ),
    );
  }
}
