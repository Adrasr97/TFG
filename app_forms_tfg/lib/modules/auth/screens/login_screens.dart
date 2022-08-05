import 'package:app_forms_tfg/layout/widgets/buttons/email_sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode = false;
    double buttonHeight = 40;
    double buttonWidth = 300;

    return Scaffold(
        body: Center(
      child: SizedBox(
        height: 550,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: ListView(
            padding: const EdgeInsets.all(0),
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: SizedBox(
                  height: 200,
                  child: Image.asset(
                    //"assets/images/logo-dynamic-forms-icono.png",
                    "assets/images/4.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    margin: const EdgeInsets.all(8),
                    child: EmailSignInButton(
                      darkMode: darkMode,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
