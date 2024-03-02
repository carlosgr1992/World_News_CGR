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
          leading: Image.network(noticia.urlImagen, width: 100, fit: BoxFit.cover),
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
          child: Column(
            children: <Widget>[
              Image.network(noticia.urlImagen, height: 100, fit: BoxFit.cover),
              Text(noticia.titulo),
            ],
          ),
        );
      },
    );
  }
}
