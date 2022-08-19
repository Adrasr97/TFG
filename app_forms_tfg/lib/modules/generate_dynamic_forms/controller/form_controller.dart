import 'package:app_forms_tfg/models/form_model.dart';
import 'package:app_forms_tfg/models/modelo_formulario.dart';
import 'package:app_forms_tfg/services/firestore_service_forms.dart';
import 'package:app_forms_tfg/services/firestore_services_form_design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  Rx<List<Formulario>> formsList = Rx<List<Formulario>>([]);

  TextEditingController nameFormController = TextEditingController();
  TextEditingController descriptionFormController = TextEditingController();

  FirestoreFormDesign databaseForms = FirestoreFormDesign();

  static FormController to = Get.find();

  @override
  void onReady() {
    formsList.bindStream(databaseForms.formsStream());
    super.onReady();
  }
}
