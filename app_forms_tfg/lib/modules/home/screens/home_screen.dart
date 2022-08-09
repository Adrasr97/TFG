import 'package:app_forms_tfg/models/form_model.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/controller/form_controller.dart';
import 'package:app_forms_tfg/services/firestore_service_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

import '../../generate_dynamic_forms/controller/form_controller.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = AuthController.to;
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormModel formModel = FormModel(
        description: "Hola soy un formulario 3", name: "nuevo formulario 3");
    return Scaffold(
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
              heroTag: "Boton 1",
              child: const Icon(Icons.add),
              onPressed: () {
                DatabaseForms().createNewForm(
                  model: formModel,
                  user: authController.firebaseUser.value!,
                );
              }),
          FloatingActionButton(
              heroTag: "Boton 2",
              child: const Icon(Icons.person),
              onPressed: () {
                authController.signOut();
              }),
        ],
      ),
      body: GetBuilder<FormController>(
        builder: (formController) => Obx(
          () => ListView.builder(
            itemCount: formController.formsList.value.length,
            itemBuilder: (context, index) {
              return Text(
                formController.formsList.value[index].uid!,
              );
            },
          ),
        ),
      ),
    );
  }
}
