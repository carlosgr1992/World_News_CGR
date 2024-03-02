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
}
