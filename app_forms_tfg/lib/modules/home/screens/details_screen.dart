
import 'package:app_forms_tfg/models/modelo_formulario.dart';
import 'package:app_forms_tfg/services/firestore_services_form_design.dart';
import 'package:app_forms_tfg/services/sqlite_database.dart';
import 'package:expression_language/expression_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
as components;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DetailsScreen extends StatefulWidget {
  final Formulario formModel;
  const DetailsScreen({Key? key, required this.formModel}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  final SQLiteDatabase sqLiteDatabase = SQLiteDatabase();
  final FirestoreFormDesign firestoreFormDesign = FirestoreFormDesign();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: ParsedFormProvider(
          create: (_) => JsonFormManager(),
          content: (widget.formModel.estructura ??= ''),
          //content:
          //    "{\"@name\":\"form\",\"icon\":\"0xe045\",\"titulo\":\"Formulario 2\",\"id\":\"form2\",\"children\":[{\"@name\":\"textField\",\"id\":\"sourceText\",\"label\":\"Enter custom text\",\"value\":\"Hello\"},{\"@name\":\"label\",\"value\":{\"expression\":\"\\\"This is your text in upper case: \\\"  + enMayuscula(@sourceText.value)\"}}]}",
          parsers: components.getDefaultParserList(),
          child: Column(
            children: [
              FormRenderer<JsonFormManager>(
                renderers: components.getRenderers(),
              ),
              // Se usa Builder para obtener un contexto (BuildContext) que ya contenga al JsonFormManager
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    child: const Text("Grabar"),
                    onPressed: () async{
                      var formProperties =
                      FormProvider.of<JsonFormManager>(context)
                          .getFormProperties();
                      await _submitToServer(context, formProperties);
                      //Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
          expressionFactories: [
            ExplicitFunctionExpressionFactory(
              name: 'enMayuscula',
              parametersLength: 1,
              createFunctionExpression: (parameters) =>
                  ToUpperCaseExpression(parameters[0] as Expression<String>),
            ),
            ExplicitFunctionExpressionFactory(
              name: 'selectNumberProperty',
              parametersLength: 2,
              createFunctionExpression: (parameters) =>
                  SelectNumberPropertyExpression(
                      parameters[0]
                      as Expression<List<ExpressionProviderElement>>,
                      parameters[1] as Expression<String>),
            ),
            ExplicitFunctionExpressionFactory(
              name: 'sumNumbers',
              parametersLength: 1,
              createFunctionExpression: (parameters) => SumNumbersExpression(
                  parameters[0] as Expression<List<Expression<Number>>>),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _submitToServer(
      BuildContext context, List<FormPropertyValue> formProperties) async {
    try{
      await sqLiteDatabase.saveData(widget.formModel, formProperties);
      await firestoreFormDesign.syncFormData();

      final snackBar = new SnackBar(content: new Text('Datos guardados y sincronizados'),
          backgroundColor: Colors.green);

      // Find the Scaffold in the Widget tree and use it to show a SnackBar!
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Get.back();
    }catch(ex){
      log('ocurrio un error al guardar datos');
      log(ex.toString());
      final snackBar = new SnackBar(content: new Text(ex.toString()),
          backgroundColor: Colors.red);

      // Find the Scaffold in the Widget tree and use it to show a SnackBar!
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

}


class SelectNumberPropertyExpression<T extends ExpressionProviderElement>
    extends Expression<List<Expression<Number>>> {
  final Expression<List<T>> value;
  final Expression<String> selectorPropertyName;

  SelectNumberPropertyExpression(this.value, this.selectorPropertyName);

  @override
  Expression<List<Expression<Number>>> clone(
      Map<String, ExpressionProviderElement> elementMap) {
    return SelectNumberPropertyExpression<T>(
        value.clone(elementMap), selectorPropertyName.clone(elementMap));
  }

  @override
  List<Expression<Number>> evaluate() {
    var propertyName = selectorPropertyName.evaluate();
    var delegateExpressions = value
        .evaluate()
        .map((e) => createDelegateExpression(
        [e.id!], e.getExpressionProvider(propertyName)))
        .cast<Expression<Number?>>()
        .map((e) => NullableToNonNullableExpression(e))
        .toList();

    return delegateExpressions;
  }

  @override
  List<Expression> getChildren() {
    return [
      value,
      ...evaluate(), // expressions from the selector must be included as well
      selectorPropertyName,
    ];
  }
}

class SumNumbersExpression extends Expression<Number> {
  final Expression<List<Expression<Number>>> value;

  SumNumbersExpression(this.value);

  @override
  Expression<Number> clone(Map<String, ExpressionProviderElement> elementMap) {
    return SumNumbersExpression(value.clone(elementMap));
  }

  @override
  Number evaluate() {
    return value
        .evaluate()
        .map((v) => v.evaluate())
        .fold(Integer(0), (previous, current) => previous + current);
  }

  @override
  List<Expression> getChildren() {
    return [value];
  }
}

class ToUpperCaseExpression extends Expression<String> {
  final Expression<String> value;

  ToUpperCaseExpression(this.value);

  @override
  Expression<String> clone(Map<String, ExpressionProviderElement> elementMap) {
    return ToUpperCaseExpression(value.clone(elementMap));
  }

  @override
  String evaluate() {
    return value.evaluate().toUpperCase();
  }

  @override
  List<Expression> getChildren() {
    return [
      value,
    ];
  }
}
