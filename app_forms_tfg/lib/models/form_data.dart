import 'dart:developer';

class FormData {
  final String id;
  final String formulario;
  final int versionFormulario;
  final String titulo;
  final String subtitulo;
  String? valores;
  int uploaded;

  /// Modelo de datos
  FormData(
      {required this.id,
      required this.formulario,
      required this.versionFormulario,
      required this.titulo,
      required this.subtitulo,
      this.valores,
      this.uploaded = 0});

  Map<String, dynamic> toMap() {
    log('Mapeando Dato $id:');
    log(toString());
    return {
      'id': id,
      'formulario': formulario,
      'versionFormulario': versionFormulario,
      'titulo': titulo,
      'subtitulo': subtitulo,
      'valores': valores,
      'uploaded': uploaded
    };
  }

  @override
  String toString() {
    return '{id: $id,formulario: $formulario,versionFormulario: $versionFormulario,titulo: $titulo,subtitulo: $subtitulo,valores: $valores}';
  }
}
