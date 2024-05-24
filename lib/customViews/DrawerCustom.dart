import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../fireStoreObjects/FbUsuario.dart';

class DrawerCustom extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<FbUsuario>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            User? currentUser = _auth.currentUser;
            String welcomeText = 'Bienvenido, ${snapshot.data?.nombre ?? currentUser?.email ?? 'Invitado'}';

            return ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(70), // Radio de borde para redondear la imagen
                        child: Image.asset(
                          'images/imagenPredeterminada.jpeg', // Ruta de la imagen de la aplicación
                          width: 140, // Ancho deseado de la imagen
                          height: 100, // Alto deseado de la imagen
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        welcomeText,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Perfil'),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/registerDataUser");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Noticias Favoritas'),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/favoritosView");
                  },
                ),

                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuración'),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/configuracionView");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).popAndPushNamed("/homeView");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.of(context).popAndPushNamed("/loginMobile");
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<FbUsuario> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection("Usuarios").doc(user.uid).get();
      if (userSnapshot.exists) {
        return FbUsuario.fromFirestore(userSnapshot);
      }
    }
    return FbUsuario(nombre: '', apellidos: '', edad: 0); // Si no se encuentra el usuario, se devuelve un FbUsuario vacío
  }
}
