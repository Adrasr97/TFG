import 'package:app_forms_tfg/firebase_options.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/auth/screens/splash_screen.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/controller/form_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // función asíncrona de Firebase que inicializa una nueva [FirebaseApp] y devuelve la aplicación creada
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Instanciar el controlador para la autenticación
  Get.put<AuthController>(AuthController());
  // Instanciar el controlador para la lista de formularios
  Get.put<FormController>(FormController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Forms',
      home: SplashScreen(),
    );
  }
}
