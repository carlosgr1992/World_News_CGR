import 'package:flutter/material.dart';
import '../apis/NoticiasAPI.dart';
import '../fireStoreObjects/Noticia.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Noticia> _noticias = [];
  bool isList = true; // Predeterminado a true para mostrar ListView

  @override
  void initState() {
    super.initState();
    _cargarNoticias();
  }

  _cargarNoticias() async {
    var noticiasApi = NoticiasAPI();
    var noticias = await noticiasApi.getTopHeadlines();
    setState(() {
      _noticias = noticias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias'),
      ),
      body: isList ? _buildListView() : _buildGridView(),
      // Botón para alternar entre vistas
      floatingActionButton: FloatingActionButton(
        child: Icon(isList ? Icons.grid_on : Icons.list),
        onPressed: () {
          setState(() {
            isList = !isList;
          });
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _noticias.length,
      itemBuilder: (context, index) {
        var noticia = _noticias[index];
        return ListTile(
          leading: SizedBox(
            width: 100,
            height: 56, // Ajustamos un tamaño porque da errores al quererse expandir más de lo debido
            child: Image.network(
              noticia.urlImagen.isNotEmpty ? noticia.urlImagen : 'images/imagenPredeterminada.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover);
              },
            ),
          ),
          title: Text(noticia.titulo),
          subtitle: Text(noticia.descripcion),
        );
      },
    );
  }



  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1, // Ajusta esto según tus necesidades
      ),
      itemCount: _noticias.length,
      itemBuilder: (context, index) {
        var noticia = _noticias[index];
        var imageUrl = noticia.urlImagen.isNotEmpty ? noticia.urlImagen : null;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: imageUrl != null
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Si la imagen de la red falla, se muestra la imagen de reserva
                    return Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover);
                  },
                )
                    : Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover), // Imagen de reserva
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  noticia.titulo,
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }




}
