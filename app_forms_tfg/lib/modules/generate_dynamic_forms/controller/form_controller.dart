import 'package:app_forms_tfg/models/form_model.dart';
import 'package:app_forms_tfg/services/firestore_service_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  Rx<List<FormModel>> formsList = Rx<List<FormModel>>([]);

  TextEditingController nameFormController = TextEditingController();
  TextEditingController descriptionFormController = TextEditingController();

  DatabaseForms databaseForms = DatabaseForms();

  static FormController to = Get.find();

  @override
  void onReady() {
    formsList.bindStream(databaseForms.formsStream());
    super.onReady();
  }
}
