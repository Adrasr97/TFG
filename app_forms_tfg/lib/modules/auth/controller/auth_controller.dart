import 'dart:developer';

import 'package:app_forms_tfg/layout/widgets/buttons/email_sign_in_button.dart';
import 'package:app_forms_tfg/modules/auth/screens/email_sign_in_ui.dart';
import 'package:app_forms_tfg/modules/auth/screens/login_screens.dart';
import 'package:app_forms_tfg/modules/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Controladores para manejar los datos de email y contraseña del usuario
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //TextEditingController nameController = TextEditingController();

  // Rxn hará que firebaseUser sea una variable observable, si sufre algun cambio se notifica
  // User es el Modelo de Usuario de Firebase
  Rxn<User> firebaseUser = Rxn<User>();

  // Declarar la instancia de Get.find para acceder al controlador con el método to
  static AuthController to = Get.find();

  // Cuando el controlador esté list ose ejecuta lo que hay dentro de onReady()
  // Permite identficiar si el usuario existe
  @override
  void onReady() {
    // run every time auth state changes, siempre que firebaseUser sufra cambio, se llama al handler
    ever(firebaseUser, handleAuthChanged);

    // bindStream pertenece a GetX para que cuando haya cambio se notifique en la pantalla
    firebaseUser.bindStream(user);

    super.onReady();
  }

  handleAuthChanged(firebaseUser) async {
    // Para identificar si el usuario existe o no

    if (firebaseUser == null) {
      Get.offAll(
          // Si no existe cerramos a todas las paginas y navega a la pantalla de login
          //const LoginScreen());
          EmailSignInUi());
    } else {
      Get.offAll(HomeScreen());
    }
  }

  // Firebase user a realtime stream
  // Permite notificar en caso de que haya cambios en el User
  // Todos los cambios sobre el usuario serán notificados a través de este Stream
  Stream<User?> get user => _auth.authStateChanges();

  // Sign out para cerrar sesión
  Future<void> signOut() {
    return _auth.signOut();
  }

  // Method to handle user sign in using email and password
  signInWithEmailAndPassword(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        // trim para deshacerse de los espacios
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Firebase lanza sus propios erroes para la autenticación
      log('$e');
    }
  }

  // User registration using email and password
  registerwithEmailAndPassword(BuildContext context) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        //name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      )
          .then((result) async {
        print(
          "Uid: " + result.user!.uid.toString(),
        );
        print(
          "Email: " + result.user!.email.toString(),
        ); /*
        print(
          "Nombre: " + result.user!.name.toString(),
        );*/
      });
    } on FirebaseAuthException catch (e) {
      // Firebase lanza sus propios erroes para la autenticación
      log('$e');
    }
  }
}
