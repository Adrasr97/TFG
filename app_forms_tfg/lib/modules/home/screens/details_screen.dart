import 'package:app_forms_tfg/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  final FormModel formModel;
  const DetailsScreen({Key? key, required this.formModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.back();
      }),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(formModel.name!),
                Text(formModel.uidUser!),
                Text(formModel.description!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
