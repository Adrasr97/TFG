class Validator {
  Validator();

  String? email(String? value) {
    // restricción para que el campo tenga la estructura de un correo electrónico
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce un Email válido';
    } else {
      return null;
    }
  }

  String? password(String? value) {
    // se aceptan todos los caracteres
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce una contraseña válida';
    } else {
      return null;
    }
  }

/*
  String? name(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce un nombre válido';
    } else {
      return null;
    }
  }
  */
}
