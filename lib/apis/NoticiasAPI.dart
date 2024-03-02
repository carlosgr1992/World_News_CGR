import 'dart:convert';
import 'package:http/http.dart' as http;
import '../fireStoreObjects/Noticia.dart';

class NoticiasAPI {
  final String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = '83501336736d4dcbaf95af4f2a9f1e60';

  Future<List<Noticia>> getTopHeadlines() async {
    final url = Uri.parse('$_baseUrl/everything?q=*&language=es&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<dynamic> articles = decodedData['articles'];

      return articles.map<Noticia>((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

  // Cargar filtros por categorías
  Future<List<Noticia>> getNoticiasPorCategoria(String categoria) async {
    final url = Uri.parse('$_baseUrl/everything?q=$categoria&language=es&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<dynamic> articles = decodedData['articles'];
      return articles.map<Noticia>((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news for category $categoria in Spanish');
    }
  }
  // Obtenemos los detalles de la noticia para el muestraFavoritosView
  Future<Noticia> obtenerDetallesNoticia(String noticiaId) async {
    final url = Uri.parse('$_baseUrl/everything?q=$noticiaId&apiKey=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      // Asumiendo que 'articles' es una lista de noticias
      final Map<String, dynamic> articleData = decodedData['articles'].firstWhere((article) => article['id'] == noticiaId);
      return Noticia.fromJson(articleData);
    } else {
      // Manejar el error como consideres adecuado
      throw Exception('Error al cargar detalles de la noticia: ${response.statusCode}');
    }
  }

}
