import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                    /* Añadir movimiento al enlace, hacer más adelante ya que es bastante complejo, agregar
                    url_launcher como dependencia, subir el sdk a 24 y ajustar las versiones para compatibilidad
                     */
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.star_border),
        onPressed: () => gestionarFavoritos(noticia,context),
      ),
    );

  }

  Future<void> gestionarFavoritos(Noticia? noticia, BuildContext context) async {
    if (noticia == null) return;

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference favoritosRef = FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).collection('Favoritos');

    List favoritos = []; // Definir una lista vacía por ahora

    // Obtener los documentos de la subcolección "Favoritos"
    QuerySnapshot favoritosSnapshot = await favoritosRef.get();

    // Iterar sobre los documentos y agregarlos a la lista "favoritos"
    favoritosSnapshot.docs.forEach((doc) {
      favoritos.add(doc.data());
    });

    var match = favoritos.firstWhere(
          (fav) => fav['title'] == noticia.titulo && fav['urlNoticia'] == noticia.urlNoticia,
      orElse: () => null,
    );

    if (match != null) {
      // La noticia ya está en favoritos, procedemos a eliminarla
      await favoritosRef.doc(match['id']).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Noticia eliminada de favoritos.'),
        duration: Duration(seconds: 2),
      ));
    } else {
      // La noticia no está en favoritos, procedemos a añadirla
      await favoritosRef.add({
        'title': noticia.titulo,
        'description': noticia.descripcion,
        'urlToImage': noticia.urlImagen,
        'url': noticia.urlNoticia,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Noticia añadida a favoritos.'),
        duration: Duration(seconds: 2),
      ));
    }
  }




}
