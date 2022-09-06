import 'package:flutter/widgets.dart';


class FormVerticalSpacing extends StatelessWidget {

  /// agregar espacio vertical de 24 puntos
  const FormVerticalSpacing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24.0,
    );
  }
}
