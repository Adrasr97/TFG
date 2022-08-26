import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/data/data_list.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/controller/form_controller.dart';
import 'package:app_forms_tfg/modules/home/screens/details_screen.dart';
import 'package:app_forms_tfg/services/firestore_services_form_design.dart';
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
  final FirestoreFormDesign firestoreFormDesign = FirestoreFormDesign();

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Salir':
        authController.signOut();
        break;
      case 'Sincronizar':
        try {
          await firestoreFormDesign.syncFormData();
          final snackBar = new SnackBar(
              content: new Text('Datos sincronizados'),
              backgroundColor: Colors.green);

          // Find the Scaffold in the Widget tree and use it to show a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } catch (ex) {
          final snackBar = new SnackBar(
              content: new Text(ex.toString()), backgroundColor: Colors.red);

          // Find the Scaffold in the Widget tree and use it to show a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text("Formularios"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async => await handleClick(value),
            itemBuilder: (BuildContext context) {
              return {'Salir', 'Sincronizar'}.map((String choice) {
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
                  Get.to(
                      () => /*DetailsScreen(
                        formModel: formController.formsList.value[index],
                      )*/

                          DataList(
                              formulario:
                                  formController.formsList.value[index]))
                },
                child: Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            formController.formsList.value[index].titulo,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          leading: Icon(IconData(
                              int.parse(
                                  formController.formsList.value[index]!.icono),
                              fontFamily: 'MaterialIcons')),
                          trailing: Text(
                              'version ${formController.formsList.value[index].version}'),
                        ))),
              );
            },
          ),
        ),
      ),
    );
  }
}
