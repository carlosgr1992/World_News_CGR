class Noticia {

  final String titulo;
  final String descripcion;
  final String urlImagen;
  final String urlNoticia;
  final String contenido;

  Noticia({
    required this.titulo,
    required this.descripcion,
    required this.urlImagen,
    required this.urlNoticia,
    required this.contenido,
  });

  Noticia.fromJson(Map<String, dynamic> json)
      : titulo = json['title'] ?? 'Título no disponible',
        descripcion = json['description'] ?? 'Descripción no disponible',
        urlImagen = json['urlToImage'] ?? '',
        urlNoticia = json['url'] ?? '',
        contenido = json['content'] ?? '';

}