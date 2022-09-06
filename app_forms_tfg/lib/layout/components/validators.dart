class Validator {
  Validator();


  /// restricción para que el campo tenga la estructura de un correo electrónico
  String? email(String? value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce un Email válido';
    } else {
      return null;
    }
  }

  /// se aceptan todos los caracteres
  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce una contraseña válida';
    } else {
      return null;
    }
  }

}
