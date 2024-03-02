import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../fireStoreObjects/FbUsuario.dart';

class DrawerCustom extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(Icons.person, size: 40),
                  radius: 40,
                ),
                SizedBox(height: 10),
                Text(
                  'Bienvenido, ${currentUser?.email ?? 'Invitado'}',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Noticias Favoritas'),
            onTap: () {
              Navigator.of(context).popAndPushNamed("/favoritosView");
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
              Navigator.of(context).popAndPushNamed("/loginView");
            },
          ),
        ],
      ),
    );
  }
}
