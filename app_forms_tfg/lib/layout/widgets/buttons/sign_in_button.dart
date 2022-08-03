import 'package:flutter/material.dart';

const double defaultBorderRadius = 3.0;

class SignInButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final Widget leading;
  final Color leadingBackground;
  final double borderRadius;
  final VoidCallback onPressed;

  final bool centered;

  const SignInButton(
      {required this.onPressed,
      required this.text,
      required this.buttonColor,
      required this.textColor,
      required this.leading,
      required this.leadingBackground,
      this.borderRadius = defaultBorderRadius,
      this.centered = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 40.0,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                height: 38.0, // 40dp - 2*1dp border
                width: 38.0, // matches above
                decoration: BoxDecoration(
                  color: leadingBackground,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Center(
                    child: SizedBox(
                  height: 24,
                  width: 24,
                  child: leading,
                )),
              ),
            ),
            Expanded(
              child: Container(
                alignment: centered ? Alignment.center : Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
