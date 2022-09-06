import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  /// Pantalla intermedia durante el tiempo de carga de la aplicación
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircleAvatar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          radius: 120.0,
          child: ClipOval(
            child: Image.asset(
              "assets/icon/icon.png",
              fit: BoxFit.cover,
              height: 240,
              width: 240,
            ),
          ),
        ),
      ),
    );
  }
}
