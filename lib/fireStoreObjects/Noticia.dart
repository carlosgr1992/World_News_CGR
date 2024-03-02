
class Noticia {

  final String titulo;
  final String descripcion;
  final String urlImagen;
  final String urlNoticia;

  Noticia({
    required this.titulo,
    required this.descripcion,
    required this.urlImagen,
    required this.urlNoticia
});

  Noticia.fromJson(Map<String, dynamic> json)
      : titulo = json['title'],
        descripcion = json['description'],
        urlImagen = json['urlToImage'],
        urlNoticia = json['url'];

}