import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../customViews/TextButtonCustom.dart';
import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/DataHolder.dart';


class LoginView extends StatelessWidget {

  final TextEditingController tecEmailController = TextEditingController();
  final TextEditingController tecPassController = TextEditingController();
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context=context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Color(0xFFFEFFDE),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Text(
              "Bienvenido al login",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 80),
            TextField(
              controller: tecEmailController,
              decoration: InputDecoration(
                fillColor: Color(0xFFBAF9FF),
                filled: true,
                hintText: "Introduzca su usuario",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: tecPassController,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Color(0xFFBAF9FF),
                filled: true,
                hintText: "introduzca contraseña",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                ),
                TextButtonCustom(onPressed: onClickLogin, text: "Login"),
                SizedBox(
                  width: 50,
                ),
                TextButtonCustom(onPressed: onClickRegister, text: "Registrar"),
              ],
            )
          ],
        ),
      ),
    );
  }

  void onClickRegister(){

    Navigator.of(_context).popAndPushNamed("/registerView");

  }

  void onClickLogin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: tecEmailController.text,
          password: tecPassController.text
      );
      FbUsuario? user = await DataHolder.firebaseAdmin.loadFbUsuario();

      if (user != null) {
        Navigator.of(_context).popAndPushNamed("/homeView");
      }
      else {
        Navigator.of(_context).popAndPushNamed("/registerDataUser");
      }
    } on FirebaseAuthException catch (e) {
      print('Entro en el catch');
      print('No user found for that email.');
      if (e.code == 'user-not-found') {
        print('Correo no encontrado.');
      } else if (e.code == 'wrong-password') {
        print('Contraseña incorrecta.');
      } else if (e.code == 'user-not-found' && e.code == 'wrong-password') {
        print('Correo y contraseña incorrecta.');
      }
    }
  }
  }