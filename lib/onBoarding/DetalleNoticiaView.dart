import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../fireStoreObjects/Noticia.dart';


class DetalleNoticiaView extends StatelessWidget {
  final Noticia? noticia;

  DetalleNoticiaView({this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noticia?.titulo ?? 'Detalle de Noticia'),
      ),
      body: ListView(
        children: [
          Image.network(
            noticia?.urlImagen.isNotEmpty ?? false ? noticia!.urlImagen : 'images/imagenPredeterminada.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover);
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noticia?.titulo ?? 'Titulo no disponible',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  noticia?.descripcion ?? 'Descripción no disponible',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                SelectableText(
                  '${noticia?.urlNoticia}',
                  style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
                  onTap: () {
                    // Código para abrir la URL
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16,
            left: 32,
            child: FloatingActionButton(
              heroTag: 'shareButton', // Asignar un heroTag único
              child: Icon(Icons.share),
              onPressed: () => _compartirNoticia(noticia),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'favoriteButton', // Asignar un heroTag único
              child: Icon(Icons.star_border),
              onPressed: () => gestionarFavoritos(noticia, context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> gestionarFavoritos(Noticia? noticia, BuildContext context) async {
    if (noticia == null) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference favoritosRef = FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).collection('Favoritos');

    QuerySnapshot matchingNoticias = await favoritosRef.where('urlNoticia', isEqualTo: noticia.urlNoticia).limit(1).get();

    if (matchingNoticias.docs.isNotEmpty) {
      await matchingNoticias.docs.first.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Noticia eliminada de favoritos.'),
        duration: Duration(seconds: 2),
      ));
    } else {
      await favoritosRef.add({
        'title': noticia.titulo,
        'description': noticia.descripcion,
        'urlToImage': noticia.urlImagen,
        'urlNoticia': noticia.urlNoticia,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Noticia añadida a favoritos.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void _compartirNoticia(Noticia? noticia) {
    if (noticia == null) return;
    final String url = noticia.urlNoticia;
    final String titulo = noticia.titulo;

    Share.share('$titulo\n\n$url');
  }
}
