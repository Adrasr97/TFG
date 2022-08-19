import 'dart:developer';

class Formulario {
  final String id;
  final int version;
  final String titulo;
  final String icono;
  final String campoClave;
  final String campoTitulo;
  final String campoSubtitulo;
  String? estructura;

  Formulario({
    required this.id,
    required this.version,
    required this.titulo,
    required this.icono,
    required this.campoClave,
    required this.campoTitulo,
    required this.campoSubtitulo,
    this.estructura,
  });

  Map<String, dynamic> toMap() {
    //log('Mapeando Formulario $id:');
    //log(toString());
    return {
      'id': id,
      'version': version,
      'titulo': titulo,
      'icono': icono,
      'campoClave': campoClave,
      'campoTitulo': campoTitulo,
      'campoSubtitulo': campoSubtitulo,
      'estructura': estructura,
    };
  }

  @override
  String toString() {
    return '{id: $id, version: $version, titulo: $titulo, icono: $icono, campoClave: $campoClave, campoTitulo: $campoTitulo, campoSubtitulo: $campoSubtitulo, estructura: $estructura}';
  }
}
