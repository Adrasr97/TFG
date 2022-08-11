import 'dart:ffi';

import 'package:app_forms_tfg/models/form_model.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/views/create_empty_form_screen.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/views/create_text_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypesFormsScreen extends StatelessWidget {
  const TypesFormsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
      ),
      body: ListView.builder(
        itemCount: TypeForm.values.length,
        itemBuilder: (context, index) {
          return TextButton(
              onPressed: () {
                if (TypeForm.values[index].name == TypeForm.emptyForm.name) {
                  Get.to(CreateEmptyFormScreen());
                } else if (TypeForm.values[index].name ==
                    TypeForm.textForm.name) {
                  Get.to(CreateTextFormScreen());
                } else {
                  print("otroooooo");
                }
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    height: 50,
                    color: Colors.pink,
                    child: Text(TypeForm.values[index].name),
                  )));
        },
      ),
    );
  }
}
