import 'package:app_forms_tfg/models/form_model.dart';
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
        print(mapData['data']);
      }

      return retVal;
    });
  }

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
  }
}
