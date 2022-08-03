import 'package:flutter/material.dart';

// Cambiar nombre a Init Screen ?
// Splash Screen es una pantalla intermedia por si tarda en cargar la aplicación
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
