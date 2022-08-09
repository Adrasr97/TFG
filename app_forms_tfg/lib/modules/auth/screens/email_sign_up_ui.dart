import 'package:app_forms_tfg/layout/components/validators.dart';
import 'package:app_forms_tfg/layout/spaces/form_vertical_spacing.dart';
import 'package:app_forms_tfg/layout/widgets/buttons/label_button.dart';
import 'package:app_forms_tfg/layout/widgets/buttons/primary_button.dart';
import 'package:app_forms_tfg/layout/widgets/forms/form_input_field_with_icon.dart';
import 'package:app_forms_tfg/modules/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'email_sign_in_ui.dart';

class EmailSignUpUi extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Key del formulario

  EmailSignUpUi({Key? key}) : super(key: key);

  //static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CircleAvatar(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        radius: 120.0,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/flutteracademy-logo.png",
                            fit: BoxFit.cover,
                            height: 240,
                            width: 240,
                          ),
                        ),
                      ),
                      /*FormInputFieldWithIcon(
                        // NOMBRE
                        controller: authController.nameController,
                        iconPrefix: Icons.person,
                        labelText: 'Nombre',
                        validator: Validator().name,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.nameController.text = value!,
                      ),
                      const FormVerticalSpacing(),*/
                      FormInputFieldWithIcon(
                        // EMAIL
                        controller: authController.emailController,
                        iconPrefix: Icons.email,
                        labelText: 'Email',
                        validator: Validator().email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.emailController.text = value!,
                      ),
                      const FormVerticalSpacing(),
                      FormInputFieldWithIcon(
                        // PASSWORD
                        controller: authController.passwordController,
                        iconPrefix: Icons.lock,
                        labelText: 'Contraseña',
                        validator: Validator().password,
                        obscureText: true,
                        onChanged: (value) => null,
                        onSaved: (value) =>
                            authController.passwordController.text = value!,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PrimaryButton(
                          labelText: 'Inscribirse',
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              SystemChannels.textInput.invokeMethod(
                                  'TextInput.hide'); //to hide the keyboard - if any
                              authController
                                  .registerwithEmailAndPassword(context);
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      LabelButton(
                        labelText: '¿Tienes una cuenta? Iniciar sesión.',
                        onPressed: () => Get.off(EmailSignInUi()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
