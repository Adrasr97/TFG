import 'dart:convert';
import 'dart:developer';

import 'package:app_forms_tfg/models/modelo_formulario.dart';
import 'package:app_forms_tfg/services/sqlite_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreFormDesign {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SQLiteDatabase _sqLiteDatabase = SQLiteDatabase();

  static String _collection = "designs";

  Stream<List<Formulario>> formsStream() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Formulario> retVal = [];

      for (var element in query.docs) {
        print('firebase form${element}');

        var mapData = element.data() as Map<String, dynamic>;
        //Formulario f = jsonDecode(mapData['data']);
        print('formulario -> ${mapData['data']}');

        var formDefinition = jsonDecode(mapData['data']);

        var formulario = Formulario(
          id: formDefinition['id'],
          version: formDefinition['version'] ?? 1,
          titulo: formDefinition['titulo'],
          icono: formDefinition['icon'],
          campoClave: formDefinition['campoClave'] ?? '',
          campoTitulo: formDefinition['campoTitulo'] ?? '',
          campoSubtitulo: formDefinition['campoSubtitulo'] ?? '',
          estructura: jsonEncode(formDefinition),
        );

        retVal.add(formulario);
      }

      return retVal;
    });
  }

  Future<void> syncFormData() async {
    log('synFormData');

    if (_auth.currentUser == null) {
      throw Exception('Sesión no iniciada, acceda primero');
    }
    //get the user id from auth
    final userUid = _auth.currentUser!.uid;

    //query from database
    //TODO queda pendiente asociar data a cada user
    var dataQuery = await _sqLiteDatabase.getNotUploadedData();

    log('data to upload: ${dataQuery.isNotEmpty}');

    //firestore
    //user/zasdfs51263/data/form1-1-jonathan
    //                      ...properties
    //

    //extraer todo lo de firestore a local

    if (dataQuery.isNotEmpty) {
      for (var d in dataQuery) {
        log('data to save -> $d');
        final dataId =
            '${d['formulario']}-${d['versionFormulario']}-${d['id']}';
        _firestore
            .collection('user')
            .doc(userUid)
            .collection('data')
            .doc(dataId)
            .set({
          'id': d['id'],
          'formulario': d['formulario'],
          'versionFormulario': d['versionFormulario'],
          'titulo': d['titulo'],
          'subtitulo': d['subtitulo'],
          'valores': d['valores'],
        },SetOptions(merge: true));
      }
    }

    await _sqLiteDatabase.markDataAsUploaded();


    //TODO falta sincronizar la descarga y guardar en local


  }

  /*
  Future<bool> createNewForm(
      {required FormModel model,
      required User user,
      required TypeForm form}) async {
    try {
      model.uid = _firestore.collection(_collection).doc().id;
      await _firestore.collection(_collection).doc(model.uid).set({
        "uid": model.uid,
        "name": model.name,
        "nameUser": user.displayName,
        "uidUser": user.uid,
        "description": model.description,
        "typeForm": form.name,
      });
      return true;
    } catch (e) {
      return false;
    }
  }*/
}
