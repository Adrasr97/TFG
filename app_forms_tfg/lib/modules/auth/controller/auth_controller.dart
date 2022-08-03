import 'package:app_forms_tfg/modules/auth/screens/login_screens.dart';
import 'package:app_forms_tfg/modules/home/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          const LoginScreen());
    } else {
      Get.offAll(const HomeScreen());
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
}
