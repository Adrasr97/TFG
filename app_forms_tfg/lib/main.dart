import 'package:app_forms_tfg/firebase_options.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/auth/screens/splash_screen.dart';
import 'package:app_forms_tfg/modules/home/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Instanciar el controlador para la Autenticación
  Get.put<AuthController>(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Material App',
      home: SplashScreen(),
    );
  }
}
