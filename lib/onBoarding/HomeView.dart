import 'package:flutter/material.dart';
import '../apis/NoticiasAPI.dart';
import '../customViews/DrawerCustom.dart';
import '../fireStoreObjects/Noticia.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Noticia> _noticias = [];
  bool isList = false; // Predeterminado a false para mostrar GridView

  List<String> categorias = ['negocios', 'entretenimiento', 'todos', 'salud', 'ciencia', 'deportes', 'tecnologia'];
  String? categoriaSeleccionada = 'todos'; // Valor inicial.

  @override
  void initState() {
    super.initState();
    _cargarNoticias(categoriaSeleccionada!); // Carga inicial de noticias.
  }

  _cargarNoticias(String categoria) async {
    var noticiasApi = NoticiasAPI();
    var noticias = await noticiasApi.getNoticiasPorCategoria(categoria);
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Filtrar por categoría:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: categoriaSeleccionada,
                    onChanged: (String? nuevaCategoria) {
                      if (nuevaCategoria != null) {
                        setState(() {
                          categoriaSeleccionada = nuevaCategoria;
                          _cargarNoticias(nuevaCategoria);
                        });
                      }
                    },
                    items: categorias.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isList ? _buildListView() : _buildGridView(),
          ),
        ],
      ),
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
            height: 56,
            child: Image.network(
              noticia.urlImagen.isNotEmpty ? noticia.urlImagen : 'images/imagenPredeterminada.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover);
              },
            ),
          ),
          title: Text(
            noticia.titulo,
            maxLines: 2, // Limita el título a tres líneas
            overflow: TextOverflow.ellipsis, // Muestra puntos suspensivos si se excede el espacio
          ),
          subtitle: Text(
            noticia.descripcion,
            maxLines: 1, // Limita la descripción a tres líneas
            overflow: TextOverflow.ellipsis, // Muestra puntos suspensivos si se excede el espacio
          ),
        );
      },
    );
  }




  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        // Ajusta esto según tus necesidades
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
