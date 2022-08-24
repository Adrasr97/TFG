import 'package:app_forms_tfg/models/data_model.dart';
import 'package:app_forms_tfg/models/modelo_formulario.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:developer';
import 'package:dynamic_forms/src/form_manager/form_property_value.dart';

class SQLiteDatabase {
  final DATABASE = 'formularios.db';

  Future<void> createDatabase() async {
    try {} catch (ex) {
      log('Error al crear base de datos $ex');
    }
    final database = openDatabase(
      // Establecer el path a la base de datos
      // Note: Using the `join` function from the `path` package is best practice
      // to ensure the path is correctly constructed for each platform.
      path.join(await getDatabasesPath(), DATABASE),
      // Cuando la base de datos es creada por primera vez, se crean las tablas necesarias
      onCreate: (db, version) {
        // varchar se convierte a TEXT
        db.execute(
          'CREATE TABLE formularios(id varchar(50) PRIMARY KEY, version INTEGER, titulo TEXT, icono TEXT, campoClave TEXT, campoTitulo TEXT, campoSubtitulo TEXT, estructura TEXT)',
        );
        db.execute(
          //'CREATE TABLE datos(id varchar(50), formulario varchar(50), versionFormulario INTEGER, autor TEXT, ultimaModificacion TEXT, titulo TEXT, subtitulo TEXT, valores TEXT,  PRIMARY KEY (id, formulario, versionFormulario))',
          'CREATE TABLE datos(id varchar(50), formulario varchar(50), versionFormulario INTEGER, titulo TEXT, subtitulo TEXT, valores TEXT,uploaded INTEGER,  PRIMARY KEY (id, formulario, versionFormulario))',
        );
        log('Tablas creadas.');
        return;
      },
      // Dar valor a la versión
      //Así se ejecuta la funcion onCreate y se proporciona un path en el que hacer las actualizaciones
      version: 1,
    );
  }

  Future<void> saveData(
      Formulario formModel, List<FormPropertyValue> formProperties) async {
    log('SaveData: ${formProperties}');

    try {
      final database = await openDatabase(
        path.join(await getDatabasesPath(), DATABASE),
        version: 1,
      );
      log('Database open');

      String id = '';
      String titulo = '';
      String subtitulo = '';
      String valores = '[';
      log('campoTitulo es ${formModel.campoTitulo}');
      for (var prop in formProperties) {
        log('Procesando propiedad con id ${prop.id}');
        valores +=
            '{"id":"${prop.id}","property":"${prop.property}","value":"${prop.value}"},';
        // No se usan else ifs porque la misma propiedad puede ser campo clave, título y subtítulo
        if (prop.id == formModel.campoClave) {
          id = prop.value;
        }
        if (prop.id == formModel.campoTitulo) {
          titulo = prop.value;
        }
        if (prop.id == formModel.campoSubtitulo) {
          subtitulo = prop.value;
        }
      }
      // Una vez terminado el bucle, se elimina la última coma de valores y se le añade un corchete
      valores = '${valores.substring(0, valores.length - 1)}]';
      log('values: ${valores}');
      log('Id de datos: $id');
      log('Titulo: $titulo');
      log('Subtitulo: $titulo');
      log('Id del formulario: ${formModel.id}');

      Map<String, dynamic> args = {
        'formulario': formModel.id,
        'versionFormulario': formModel.version,
        'titulo': titulo,
        'subtitulo': subtitulo,
        'valores': valores,
        'id': id,
        'uploaded': 0
      };

      log('args ${args}');

      log('check if data was insert');
      final List<Map<String, dynamic>> queryResult = await database.query(
        'datos',
        where: 'formulario=? and versionFormulario=? and titulo=?',
        whereArgs: [formModel.id, formModel.version, titulo],
      );

      log('query result: ${queryResult}');

      int res = await database.insert('datos', args,
          conflictAlgorithm: ConflictAlgorithm.replace);
      log('insert result: $res');
    } catch (ex) {
      log('error saving data: $ex');
      throw Exception('Error al guardar datos, intente de nuevo');
    }
  }

  Future<List<Map<String, dynamic>>> getNotUploadedData() async {
    //log('Leyendo datos para formulario $formId versión $formVersion');
    final database = await openDatabase(
      path.join(await getDatabasesPath(), DATABASE),
      version: 1,
    );
    final List<Map<String, dynamic>> maps = await database.query(
      'datos',
      where: 'uploaded=?',
      whereArgs: [0],
    );
    return maps;
  }

  Future<void> markDataAsUploaded() async {
    //log('Leyendo datos para formulario $formId versión $formVersion');
    final database = await openDatabase(
      path.join(await getDatabasesPath(), DATABASE),
      version: 1,
    );

    Map<String, dynamic> args = {'uploaded': 1};

    await database.update(
      'datos',
      args,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveFirestoreDataToLocal(Map<String, dynamic> firestoreData) async {
    try {
      final database = await openDatabase(
        path.join(await getDatabasesPath(), DATABASE),
        version: 1,
      );
      log('Database open');

      log('check if data was insert');
      final List<Map<String, dynamic>> queryResult = await database.query(
        'datos',
        where: 'formulario=? and versionFormulario=? and titulo=?',
        whereArgs: [firestoreData['formulario'], firestoreData['versionFormulario'], firestoreData['titulo']],
      );

      log('query result: ${queryResult}');

      int res = await database.insert('datos', firestoreData,
          conflictAlgorithm: ConflictAlgorithm.replace);
      log('insert result: $res');

    }catch(ex){
      log('error saving data: $ex');
      throw Exception('Error al guardar datos, intente de nuevo');
    }
  }

  Future<List<Dato>> readData(formId, formVersion) async {
    log('Leyendo datos para formulario $formId versión $formVersion');
    final database = await openDatabase(
        path.join(await getDatabasesPath(), 'formularios.db'),
        version: 1);
    final List<Map<String, dynamic>> maps = await database.query('datos',
        where: 'formulario=? and versionFormulario=?',
        whereArgs: [formId, formVersion]);
    log('Leídas ${maps.length} filas de la base de datos');
    // Convertir la List<Map<String, dynamic> en List<Dato>
    final datos = List.generate(maps.length, (i) {
      log('Fila $i: ${maps[i]['id']} ');
      final dato = Dato(
        id: maps[i]['id'],
        formulario: maps[i]['formulario'],
        versionFormulario: maps[i]['versionFormulario'],
        titulo: maps[i]['titulo'],
        subtitulo: maps[i]['subtitulo'],
        valores: maps[i]['valores'],
        uploaded: maps[i]['uploaded'] ?? 0
      );
      //log('Leido de DB:' + dato.toString());
      return dato;
    });
    log('Leídos ${datos.length} datos');
    return datos;
  }

  Future<void> deleteData(Dato data) async{

    final database = await openDatabase(
      path.join(await getDatabasesPath(), DATABASE),
      version: 1,
    );
    log('Database open');

    log('delete data');
     await database.delete(
      'datos',
      where: 'formulario=? and versionFormulario=? and id=?',
      whereArgs: [data.formulario, data.versionFormulario, data.id],
    );

  }

}
