import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app_forms_tfg/models/form_data.dart';
import 'package:app_forms_tfg/models/form_design.dart';
import 'package:app_forms_tfg/services/sqlite_form_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


/// maneja
class FirestoreFormDesignService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SQLiteFormDataService _sqLiteDatabase = SQLiteFormDataService();

  static String _collection = "designs";

  Stream<List<FormDesign>> formsStream() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot query) {
      List<FormDesign> retVal = [];

      for (var element in query.docs) {
        print('firebase form${element}');

        var mapData = element.data() as Map<String, dynamic>;
        //Formulario f = jsonDecode(mapData['data']);
        print('formulario -> ${mapData['data']}');

        var formDefinition = jsonDecode(mapData['data']);

        var formulario = FormDesign(
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
    log('syncFormData');

    if (_auth.currentUser == null) {
      throw Exception('Sesión no iniciada, acceda primero');
    }

    bool isConnected = false;
// use try-catch to do this operation, so that to get the control over this
// operation better
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      log('error internet connection');
    }

    if (!isConnected) {
      throw Exception('Revise su conexión a internet para sincronizar datos');
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
        await _firestore
            .collection('user')
            .doc(userUid)
            .collection('data')
            .doc(dataId)
            .set(
          {
            'id': d['id'],
            'formulario': d['formulario'],
            'versionFormulario': d['versionFormulario'],
            'titulo': d['titulo'],
            'subtitulo': d['subtitulo'],
            'valores': d['valores'],
          },
          SetOptions(merge: true),
        );
      }
    }

    await _sqLiteDatabase.markDataAsUploaded();

    var firestoreData = (await _firestore
            .collection('user')
            .doc(userUid)
            .collection('data')
            .get())
        .docs;

    //tener los elementos de firestore y guardarlos en local
    for (final firestoreElement in firestoreData) {
      var map = firestoreElement.data();
      log('firestore doc-> $map');
      await _sqLiteDatabase.saveFirestoreDataToLocal(map);
    }

    //TODO ver los datos insertados de formularios
  }

  Future<void> deleteData(FormData data) async {
    if (_auth.currentUser == null) {
      throw Exception('Sesión no iniciada, acceda primero');
    }

    bool isConnected = false;
// use try-catch to do this operation, so that to get the control over this
// operation better
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      log('error internet connection');
    }

    if (!isConnected) {
      throw Exception('Revise su conexión a internet para sincronizar datos');
    }

    //get the user id from auth
    final userUid = _auth.currentUser!.uid;

    final dataId = '${data.formulario}-${data.versionFormulario}-${data.id}';
    await _firestore
        .collection('user')
        .doc(userUid)
        .collection('data')
        .doc(dataId)
        .delete();
  }
}
