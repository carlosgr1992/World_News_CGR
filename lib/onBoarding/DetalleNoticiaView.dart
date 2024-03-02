import 'package:flutter/material.dart';
import '../fireStoreObjects/Noticia.dart';

class DetalleNoticiaView extends StatelessWidget {
  final Noticia? noticia; // Lo ponemos a posible null para el constructor del WorldNews poner tener la ruta.

  DetalleNoticiaView({this.noticia}); // Hago el parámetro opcional con '?'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noticia?.titulo ?? 'Detalle de Noticia'), // Acceso opcional a la propiedad titulo
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    noticia?.titulo ?? 'Titulo no disponible', // Acceso opcional al titulo
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    noticia?.descripcion ?? 'Descripción no disponible', // Acceso opcional a la descripcion
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
