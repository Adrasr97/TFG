import 'package:flutter/material.dart';
/*
LabelButton(
                labelText: 'Some Text',
                onPressed: () => print('implement me'),
              ),
*/

class LabelButton extends StatelessWidget {
  final String labelText;
  final void Function() onPressed;

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
