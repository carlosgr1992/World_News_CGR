import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../apis/NoticiasAPI.dart';
import '../fireStoreObjects/Noticia.dart';
import 'DetalleNoticiaView.dart';
import '../components/center_widget/center_widget.dart';  // Asegúrate de importar este archivo

class MuestraFavoritos extends StatefulWidget {
  @override
  _MuestraFavoritosState createState() => _MuestraFavoritosState();
}

class _MuestraFavoritosState extends State<MuestraFavoritos> {
  List<Noticia> _noticiasFavoritas = [];
  bool isList = false; // Añadido para cambiar entre vistas
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _cargarNoticiasFavoritas();
  }

  _cargarNoticiasFavoritas() async {
    User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario != null) {
      var favoritosSnapshot = await FirebaseFirestore.instance.collection('Usuarios').doc(usuario.uid).collection('Favoritos').get();
      var noticiasTemp = favoritosSnapshot.docs.map((doc) => Noticia.fromJson(doc.data())).toList();
      setState(() {
        _noticiasFavoritas = noticiasTemp;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias Favoritas'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -30,
            child: _topWidget(MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: -180,
            left: -40,
            child: _bottomWidget(MediaQuery.of(context).size.width),
          ),
          CenterWidget(size: MediaQuery.of(context).size),
          isLoading ? Center(child: CircularProgressIndicator()) : isList ? _buildListView() : _buildGridView(),
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

  Widget _topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * 3.14159 / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color(0x007CBFCF),
              Color(0xB316BFC4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color(0xDB4BE8CC),
            Color(0x005CDBCF),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _noticiasFavoritas.length,
      itemBuilder: (context, index) {
        var noticia = _noticiasFavoritas[index];
        return ListTile(
          leading: _buildImageView(noticia.urlImagen),
          title: Text(noticia.titulo, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(noticia.descripcion, maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () => _mostrarDetalleNoticia(noticia),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),
      itemCount: _noticiasFavoritas.length,
      itemBuilder: (context, index) {
        var noticia = _noticiasFavoritas[index];
        return GestureDetector(
          onTap: () => _mostrarDetalleNoticia(noticia),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildImageView(noticia.urlImagen)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(noticia.titulo, style: Theme.of(context).textTheme.headline6, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageView(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      return Image.asset('images/imagenPredeterminada.jpeg', fit: BoxFit.cover);
    }
  }

  void _mostrarDetalleNoticia(Noticia noticia) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetalleNoticiaView(noticia: noticia)));
  }
}
