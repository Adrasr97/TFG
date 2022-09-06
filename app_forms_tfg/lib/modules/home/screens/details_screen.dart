import 'package:app_forms_tfg/models/form_design.dart';
import 'package:app_forms_tfg/services/firestore_form_design_service.dart';
import 'package:app_forms_tfg/services/sqlite_form_data_service.dart';
import 'package:expression_language/expression_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_forms/flutter_dynamic_forms.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:dynamic_forms/dynamic_forms.dart';
import 'package:flutter_dynamic_forms_components/flutter_dynamic_forms_components.dart'
    as components;

class DetailsScreen extends StatefulWidget {
  final FormDesign formModel;
  final bool isNew;
  String campoClave;

  ///permite edición de los formularios, guardado en local y sincronizado con firebase
  DetailsScreen(
      {Key? key,
      required this.formModel,
      required this.isNew,
      required this.campoClave})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final SQLiteFormDataService sqLiteDatabase = SQLiteFormDataService();
  final FirestoreFormDesignService firestoreFormDesign =
      FirestoreFormDesignService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 35.0, bottom: 20),
        child: ParsedFormProvider(
          create: (_) => JsonFormManager(),
          content: (widget.formModel.estructura ??= ''),
          parsers: components.getDefaultParserList(),
          child: Column(
            children: [
              _keyValueWidget(),
              FormRenderer<JsonFormManager>(
                renderers: components.getRenderers(),
              ),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    child: const Text("Grabar"),
                    onPressed: () async {
                      await _submitToServer(
                          context, FormProvider.of<JsonFormManager>(context));
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
      BuildContext context, JsonFormManager jsonFormManager) async {
    bool savedLocally = false;
    try {
      // evaluar si el formulario es valido
      if (!jsonFormManager.isFormValid) {
        final snackBar = new SnackBar(
            content: new Text('Algunos campos obligatorios no tienen valor'),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      List<FormPropertyValue> formProperties =
          jsonFormManager.getFormProperties();

      //consultar si el dato existe
      final dataExist = await sqLiteDatabase.checkIfFormDataExist(
          widget.formModel, formProperties);

      //evaluar si el dato existe y si el registro es nuevo
      //no se debe registrar un identificador ya guardado
      if (dataExist && widget.isNew) {
        final snackBar = new SnackBar(
            content: new Text('Identificador ya registrado'),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }

      await sqLiteDatabase.saveData(widget.formModel, formProperties);
      savedLocally = true;
      await firestoreFormDesign.syncFormData();

      final snackBar = new SnackBar(
          content: new Text('Datos guardados y sincronizados'),
          backgroundColor: Colors.green);

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Get.back();
    } catch (ex) {
      log('ocurrio un error al guardar datos');
      log(ex.toString());

      if (savedLocally) {
        final snackBar = new SnackBar(
            content: new Text(
                'Datos guardados localmente, revise su conexión a internet para sincronizar'),
            backgroundColor: Colors.orange);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Get.back();
      } else {
        final snackBar = new SnackBar(
            content: new Text(ex.toString()), backgroundColor: Colors.red);

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget _keyValueWidget() {
    if (widget.isNew) {
      return Container();
    }

    return Text('${widget.campoClave} ');
/*    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.black45,
      title: Text('${widget.campoClave} '),
    ));*/
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
