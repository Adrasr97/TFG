import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() onPressed;
  final String labelText;

  /// botón principal con texto
  const PrimaryButton(
      {Key? key, required this.onPressed, required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(
          labelText.toUpperCase(),
        ));
  }
}
