import 'package:app_forms_tfg/models/form_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseForms {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String _collection = "forms";

  Stream<List<FormModel>> formsStream() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot query) {
      List<FormModel> retVal = [];
      for (var element in query.docs) {
        retVal.add(FormModel.fromJson(element.data() as Map<String, dynamic>));
      }

      return retVal;
    });
  }

  Future<bool> createNewForm(
      {required FormModel model, required User user}) async {
    try {
      model.uid = _firestore.collection(_collection).doc().id;
      await _firestore.collection(_collection).doc(model.uid).set({
        "uid": model.uid,
        "name": model.name,
        "nameUser": user.displayName,
        "uidUser": user.uid,
        "description": model.description,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
