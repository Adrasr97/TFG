import 'package:app_forms_tfg/models/form_design.dart';
import 'package:app_forms_tfg/services/firestore_form_design_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// controla el estado de la lista de los formularios
/// mantiene una comunicacion mediante un stream que esta constantemente escuchando los cambios producidos desde firebase
class FormController extends GetxController {
  Rx<List<FormDesign>> formsList = Rx<List<FormDesign>>([]);

  TextEditingController nameFormController = TextEditingController();
  TextEditingController descriptionFormController = TextEditingController();

  FirestoreFormDesignService databaseForms = FirestoreFormDesignService();

  static FormController to = Get.find();

  @override
  void onReady() {
    formsList.bindStream(databaseForms.formsStream());
    super.onReady();
  }
}
