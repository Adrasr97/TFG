class Validator {
  Validator();

  String? email(String? value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce un Email válido';
    } else {
      return null;
    }
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$'; // se aceptan todos los números y letras
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Introduce una contraseña válida';
    } else {
      return null;
    }
  }

  String? name(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      // aquí se puede poner poner condición de longitud
      return 'Introduce un nombre válido';
    } else {
      return null;
    }
  }

/*
// VALIDATOR NOMBRE USUARIO SING UP
  String? name(String? value) {
    // String pattern = r'^.{6,}$'; // !!! cambiar patron para validar nombre
    String pattern = r'^[a-zA-Z0-9]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Nombre no válido';
    } else {
      return null;
    }
  }
  */
}
