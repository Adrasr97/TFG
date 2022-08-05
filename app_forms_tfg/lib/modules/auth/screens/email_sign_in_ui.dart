import 'package:app_forms_tfg/layout/components/validators.dart';
import 'package:app_forms_tfg/layout/widgets/buttons/primary_button.dart';
import 'package:app_forms_tfg/layout/widgets/forms/form_input_field_with_icon.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class EmailSignInUi extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Key del formulario

  EmailSignInUi({Key? key}) : super(key: key);

  //static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormInputFieldWithIcon(
                    controller: authController.emailController,
                    iconPrefix: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email',
                    validator: Validator().email, // validacion del email
                    minLines: 1,
                    obscureText: false,
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                    onChanged: (value) =>
                        null, // no se quiere guardar el valor, el cambio ya se está manejando
                  ),
                  FormInputFieldWithIcon(
                    controller: authController.passwordController,
                    iconPrefix: Icons.lock,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Password',
                    validator: Validator().password, // validacion del email
                    minLines: 1,
                    maxLines:
                        1, // maxLines requerido para obscureText verdadero
                    obscureText:
                        true, // para ocultar los caracteres de la contraseña
                    onSaved: (value) =>
                        authController.emailController.text = value!,
                    onChanged: (value) =>
                        null, // no se quiere guardar el valor, el cambio ya se está manejando
                  ),
                  PrimaryButton(
                    labelText: 'Enviar',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // si el formulario es valido
                        authController.signInWithEmailAndPassword(context);
                      } else {}
                    },
                  )
                ]),
          ),
        ),
      )
    ]));
  }
}

/*
TutorialKart

import 'package:flutter/material.dart';

class EmailSignInUi extends StatelessWidget {
  const EmailSignInUi({Key? key}) : super(key: key);

  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'TutorialKart',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}
*/