import 'dart:convert';
import 'dart:developer';

import 'package:app_forms_tfg/models/form_data.dart';
import 'package:app_forms_tfg/models/form_design.dart';
import 'package:app_forms_tfg/services/firestore_form_design_service.dart';
import 'package:app_forms_tfg/services/sqlite_form_data_service.dart';
import 'package:flutter/material.dart';

import '../home/screens/details_screen.dart';

class DataList extends StatefulWidget {
  final FormDesign formulario;

  DataList({Key? key, required this.formulario}) : super(key: key);

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  String selectedValue = 'Editar';
  var items = ['Editar', 'Eliminar'];

  bool isLoading = true;
  final SQLiteFormDataService _sqLiteDatabase = SQLiteFormDataService();
  final FirestoreFormDesignService _firestoreFormDesign =
      FirestoreFormDesignService();

  List<FormData> _data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(widget.formulario.titulo),
        //title: Text('Título'),
      ),
      body: Center(
        child: FutureBuilder<List<FormData>>(
          future: _sqLiteDatabase.readData(
              widget.formulario.id, widget.formulario.version),
          builder: (context, snapshot) {
            // snapshot.data es formularios
            if (snapshot.hasData) {
              _data = snapshot.data!;

              return ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  FormData data = _data[index];
                  return Column(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(data.titulo),
                          subtitle: Text(data.subtitulo),
                          trailing: DropdownButton(
                            value: selectedValue,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                  value: items, child: Text(items));
                            }).toList(),
                            onChanged: (value) => {
                              if (value == 'Editar')
                                {
                                  detailsData(context, data),
                                },
                              if (value == 'Eliminar')
                                {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text("Eliminar formulario"),
                                      content: Text(
                                          "¿Seguro que quiere elimirar este formulario?"),
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
                                              deleteData(context, data);
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black45,
                                              fixedSize: const Size(15, 15),
                                            )),
                                      ],
                                    ),
                                  ),
                                }
                            },
                          ),
                          onTap: () async {},
                          tileColor: Colors.black45,
                          textColor: Colors.white,
                        ),
                        //color: Colors.red,
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // Por defecto muestra una loading spinner
            return const CircularProgressIndicator();
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                          formModel: widget.formulario,
                          isNew: true,
                          campoClave: 'N/A'),
                    )).then((_) {
                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black45,
                fixedSize: const Size(15, 15),
              ),
              child: const Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestoreFormDesign.syncFormData();
                  final snackBar = new SnackBar(
                      content: new Text('Datos sincronizados'),
                      backgroundColor: Colors.green);

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } catch (ex) {
                  final snackBar = new SnackBar(
                      content: new Text(ex.toString()),
                      backgroundColor: Colors.red);

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                //actualizar el estado de la pantalla
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black45,
                fixedSize: const Size(15, 15),
              ),
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> detailsData(BuildContext context, FormData data) async {
    // Actualizar formulario con los valores de dato
    var valores = jsonDecode(data.valores.toString());
    log('Valores: $valores');
    var estructura = widget.formulario.estructura;
    int buscarDesde = 0;
    var id;
    do {
      id = buscaValorDeClave(
        '"id"',
        estructura!,
        buscarDesde,
      );
      String propiedad = '';
      String valor = '';
      if (id[1] >= 0) {
        log('encontrada id ${id[0]} en estructura');
        valores.forEach((v) {
          if (v['id'] == id[0].replaceAll('"', '')) {
            propiedad = v['property'];
            valor = v['value'];
          }
        });
        log('propiedad $propiedad valor $valor');

        if (propiedad != '') {
          // Hay que localizar la propiedad (normalmente es value) y reemplazar su valor por la variable valor
          var valorDePropiedad = buscaValorDeClave(
            '"$propiedad"',
            estructura,
            id[1],
          );
          log('El valor de $propiedad es ${valorDePropiedad[0]} que empieza en posición ${valorDePropiedad[1]}');
          if (id[0] != '"' + widget.formulario.campoClave + '"') {
            estructura = estructura.substring(0, valorDePropiedad[1]) +
                '"' +
                valor +
                '"' +
                estructura.substring(
                    valorDePropiedad[1] + valorDePropiedad[0].length);
          } else {
            // El campo que sirve de clave primaria no será editable
            estructura = estructura.substring(0, valorDePropiedad[1]) +
                '"' +
                valor +
                '"' +
                ',"isVisible":"false"' +
                estructura.substring(
                    valorDePropiedad[1] + valorDePropiedad[0].length);
          }
        }
        buscarDesde = id[1];
      }
    } while (id[1] >= 0);
    FormDesign formularioEditado = FormDesign(
        id: widget.formulario.id,
        icono: widget.formulario.icono,
        titulo: widget.formulario.titulo,
        version: widget.formulario.version,
        campoClave: widget.formulario.campoClave,
        campoSubtitulo: widget.formulario.campoSubtitulo,
        campoTitulo: widget.formulario.campoTitulo,
        estructura: estructura);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
              formModel: formularioEditado,
              isNew: false,
              campoClave: data.titulo),
        )).then((_) {
      setState(() {});
    });
  }

  Future<void> deleteData(BuildContext context, FormData data) async {
    try {
      await _sqLiteDatabase.deleteData(data);
      await _firestoreFormDesign.deleteData(data);
      final snackBar = new SnackBar(
          content: new Text('Datos eliminados correctamente'),
          backgroundColor: Colors.green);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (ex) {
      final snackBar = new SnackBar(
          content: new Text(ex.toString()), backgroundColor: Colors.red);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //actualizar el estado de la pantalla
    setState(() {});
  }
}

// Puede ocurrir que un campo no tenga la propiedad value (o la que asigne valor al campo) en la definición del formulario, y la función devuelva esa propiedad parea un campo posterior
// Podríamos obligar a que todos los campos tengan propiedad value (o la que le corresponda), o bien detectar lo mencionado arriba
// Para detectarlo pdemos comprobar si la posición del valor de la propiedad es menor que la siguiente courrencia de "id" o algo así
List<dynamic> buscaValorDeClave(
    String clave, String json, int posicionInicial) {
  //log('Buscando $clave en ->$json<- desde posición $posicionInicial');
  int n = json.indexOf(clave, posicionInicial);
  if (n >= 0) {
    //log('id encontrado en posicion en $n: ${json.substring(n, n + 15)}');

    int m = json.indexOf(':', n);
    //log('m es $m');
    // Ahora buscamos el primer caracter no blanco a partir de m
    while (json.substring(m + 1, m + 2) == ' ') {
      m++;
      //caracter = json.substring(m + 1, m + 2);
    }
    int inicioValor = m + 1;
    //log('A partir de : ->${estructura.substring(inicioId, inicioId + 15)}<-');
    while (json.substring(m + 2, m + 3) != '"') {
      m++;
      //caracter = estructura.substring(m + 2, m + 3);
    }
    return [json.substring(inicioValor, m + 3), inicioValor];
  } else {
    return ['', -1];
  }
}
