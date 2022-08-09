import 'package:app_forms_tfg/layout/components/validators.dart';
import 'package:app_forms_tfg/layout/spaces/form_vertical_spacing.dart';
import 'package:app_forms_tfg/layout/widgets/buttons/label_button.dart';
import 'package:app_forms_tfg/layout/widgets/buttons/primary_button.dart';
import 'package:app_forms_tfg/layout/widgets/forms/form_input_field_with_icon.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:app_forms_tfg/modules/auth/screens/email_sign_up_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailSignInUi extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Key del formulario

  EmailSignInUi({Key? key}) : super(key: key);

  //static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 48.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                radius: 120.0,
                child: ClipOval(
                  child: Image.asset(
                    //"assets/images/logo-dynamic-forms-icono.png",
                    "assets/images/4.png",
                    fit: BoxFit.cover,
                    height: 240,
                    width: 240,
                  ),
                ),
              ),
              FormInputFieldWithIcon(
                // Campo de e-mail
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
              const FormVerticalSpacing(),
              FormInputFieldWithIcon(
                // Campo de contraseña
                controller: authController.passwordController,
                iconPrefix: Icons.lock,
                keyboardType: TextInputType.emailAddress,
                labelText: 'Password',
                validator: Validator().password, // validacion del email
                minLines: 1,
                maxLines: 1, // maxLines requerido para obscureText verdadero
                obscureText:
                    true, // para ocultar los caracteres de la contraseña
                onSaved: (value) =>
                    authController.emailController.text = value!,
                onChanged: (value) =>
                    null, // no se quiere guardar el valor, el cambio ya se está manejando
              ),
              const FormVerticalSpacing(),
              PrimaryButton(
                labelText: 'Enviar',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // si el formulario es valido
                    authController.signInWithEmailAndPassword(context);
                  } else {}
                },
              ),
              const FormVerticalSpacing(),
              LabelButton(
                labelText: 'Crear nueva cuenta',
                onPressed: () => Get.off(EmailSignUpUi()),
              )
            ],
          ),
        ),
      ),
    ]));
  }
}
