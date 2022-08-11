import 'package:app_forms_tfg/layout/components/validators.dart';
import 'package:app_forms_tfg/layout/widgets/buttons/primary_button.dart';
import 'package:app_forms_tfg/models/form_model.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/controller/form_controller.dart';
import 'package:app_forms_tfg/services/firestore_service_forms.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateEmptyFormScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormController formController = FormController.to;
  final AuthController authController = AuthController.to;

  CreateEmptyFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.back(); // para navegar hacia atrás hacia atrás
        // hacer que sea una flecha
      }),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                    controller: formController.nameFormController,
                    onSaved: (value) =>
                        formController.nameFormController.text == value,
                    onChanged: (value) => null,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    minLines: 1,
                    validator: Validator().name,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      filled: true,
                    ),
                    controller: formController.descriptionFormController,
                    onSaved: (value) =>
                        formController.descriptionFormController.text == value,
                    onChanged: (value) => null,
                    keyboardType: TextInputType.name,
                    maxLines: 10,
                    minLines: 3,
                    validator: Validator().name,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  PrimaryButton(
                      labelText: 'Enviar',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {}
                        FormModel formModel = FormModel(
                          description:
                              formController.descriptionFormController.text,
                          name: formController.nameFormController.text,
                        );

                        await DatabaseForms().createNewForm(
                          model: formModel,
                          user: authController.firebaseUser.value!,
                          form: TypeForm.emptyForm,
                        );

                        // Limpiar los controladores
                        formController.descriptionFormController.clear();
                        formController.nameFormController.clear();

                        //Tras enviar el formulario se vuelve a la pantalla anterior
                        Get.back();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
