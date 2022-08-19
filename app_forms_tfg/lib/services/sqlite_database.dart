import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:developer';

class SQLiteDatabase{

  Future<void> createDatabase() async {
    try{

    }catch(ex){
      log('Error al crear base de datos $ex');
    }
    final database = openDatabase(
      // Establecer el path a la base de datos
      // Note: Using the `join` function from the `path` package is best practice
      // to ensure the path is correctly constructed for each platform.
      path.join(await getDatabasesPath(), 'formularios.db'),
      // Cuando la base de datos es creada por primera vez, se crean las tablas necesarias
      onCreate: (db, version) {
        // varchar se convierte a TEXT
        db.execute(
          'CREATE TABLE formularios(id varchar(50) PRIMARY KEY, version INTEGER, titulo TEXT, icono TEXT, campoClave TEXT, campoTitulo TEXT, campoSubtitulo TEXT, estructura TEXT)',
        );
        db.execute(
          //'CREATE TABLE datos(id varchar(50), formulario varchar(50), versionFormulario INTEGER, autor TEXT, ultimaModificacion TEXT, titulo TEXT, subtitulo TEXT, valores TEXT,  PRIMARY KEY (id, formulario, versionFormulario))',
          'CREATE TABLE datos(id varchar(50), formulario varchar(50), versionFormulario INTEGER, titulo TEXT, subtitulo TEXT, valores TEXT,  PRIMARY KEY (id, formulario, versionFormulario))',
        );
        log('Tablas creadas.');
        return;
      },
      // Dar valor a la versión
      //Así se ejecuta la funcion onCreate y se proporciona un path en el que hacer las actualizaciones
      version: 1,
    );
  }
}