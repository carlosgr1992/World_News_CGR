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
                    // Añadir movimiento al enlace (hacer más adelante, muy complejo)
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
