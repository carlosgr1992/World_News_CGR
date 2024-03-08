import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/DataHolder.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    await Future.delayed(
        Duration(seconds: 3));

    if (FirebaseAuth.instance.currentUser != null) {
      // Usuario logeado
      FbUsuario? usuario = await DataHolder.firebaseAdmin.loadFbUsuario();

      if (usuario != null) {
        // Si el usuario tiene datos en Firestore, ve al Home
        Navigator.of(context).popAndPushNamed("/homeView");
      } else {
        // Si no hay usuario logeado, ve al Login
        Navigator.of(context).popAndPushNamed("/loginView");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC7DDE8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/imagenPredeterminada.jpeg"),
            Text("Cargando...", style: TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none)),
            SizedBox(height: 25),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
