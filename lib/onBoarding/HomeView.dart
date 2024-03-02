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
      ),
      itemCount: _noticias.length,
      itemBuilder: (context, index) {
        var noticia = _noticias[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Esto hará que la imagen se estire para llenar el ancho del card
            children: <Widget>[
              Expanded(
                child: Image.network(
                  noticia.urlImagen.isNotEmpty ? noticia.urlImagen : 'images/imagenPredeterminada.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover);
                  },
                ),
              ),
              ListTile(
                title: Text(noticia.titulo),
                subtitle: Text(noticia.descripcion),
              ),
            ],
          ),
        );
      },
    );
  }


}
