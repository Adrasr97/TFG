import 'dart:convert';

import 'package:app_forms_tfg/models/modelo_formulario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreFormDesign {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
