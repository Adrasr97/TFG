import 'package:flutter/material.dart';

import 'sign_in_button.dart';

class EmailSignInButton extends StatelessWidget {
  final bool darkMode;
  final VoidCallback onPressed;
  final bool centered;
  final Color lightTextColor;
  final Color lightButtonColor;
  final Color darkTextColor;
  final Color darkButtonColor;

  const EmailSignInButton(
      {required this.onPressed,
      this.darkMode = false,
      this.centered = false,
      Key? key,
      this.lightTextColor = Colors.black,
      this.lightButtonColor = Colors.white,
      this.darkTextColor = Colors.white,
      this.darkButtonColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = darkMode ? darkButtonColor : lightButtonColor;
    Color textColor = darkMode ? darkTextColor : lightTextColor;

    Widget leading = const Icon(
      Icons.email,
      color: Colors.green,
      size: 24,
    );

    return SignInButton(
      text: 'Iniciar sesión con' ' Email',
      buttonColor: buttonColor,
      textColor: textColor,
      leading: leading,
      onPressed: onPressed,
      centered: centered,
      leadingBackground: Colors.white,
    );
  }
}
