import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/data/data_list.dart';
import 'package:app_forms_tfg/modules/generate_dynamic_forms/controller/form_controller.dart';
import 'package:app_forms_tfg/services/firestore_form_design_service.dart';
import 'package:app_forms_tfg/services/sqlite_form_data_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = AuthController.to;
  final SQLiteFormDataService sqLiteDatabase = SQLiteFormDataService();
  final FirestoreFormDesignService firestoreFormDesign =
      FirestoreFormDesignService();

  Future<void> handleClick(String value) async {
    switch (value) {
      case 'Salir':
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Log out"),
            content: Text(
                "¿Seguro que quiere salir? En ausencia de internet no podrá acceder a la aplicación."),
            actions: <Widget>[
              ElevatedButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                    fixedSize: const Size(15, 15),
                  )),
              ElevatedButton(
                  child: Text("Sí"),
                  onPressed: () {
                    authController.signOut();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                    fixedSize: const Size(15, 15),
                  )),
            ],
          ),
        );

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
                  Get.to(() => DataList(
                      formulario: formController.formsList.value[index]))
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
                                  formController.formsList.value[index].icono),
                              fontFamily: 'MaterialIcons')),
                        ))),
              );
            },
          ),
        ),
      ),
    );
  }
}
