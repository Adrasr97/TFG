import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/controller/form_controller.dart';
import 'package:app_forms_tfg/modules/home/screens/details_screen.dart';
import 'package:app_forms_tfg/services/sqlite_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = AuthController.to;
  final SQLiteDatabase sqLiteDatabase = SQLiteDatabase();

  void handleClick(String value) {
    switch (value) {
      case 'Salir':
        authController.signOut();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    sqLiteDatabase.createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    //FormModel formModel = FormModel(
    //    description: "Hola soy un formulario 3", name: "nuevo formulario 3");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formularios"),
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Salir'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: GetBuilder<FormController>(
        builder: (formController) => Obx(
          () => ListView.builder(
            itemCount: formController.formsList.value.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => {
                  Get.to(() => DetailsScreen(
                        formModel: formController.formsList.value[index],
                      ))
                },
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            formController.formsList.value[index].id,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          leading: Icon(IconData(int.parse(
                              formController.formsList.value[index].icono))),
                          trailing: Text("Llenos: 0"),
                        ))),
              );
            },
          ),
        ),
      ),
    );
  }
}
