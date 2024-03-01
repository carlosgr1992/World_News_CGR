import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customViews/TextButtonCustom.dart';


class RegisterView extends StatelessWidget{
  late BuildContext _context;

  final TextEditingController tecUser = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();
  final TextEditingController tecRepeatPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
        appBar: AppBar(
          title: Text("Registro"),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Text(
                "Registro nuevos usuarios",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: tecUser,
                decoration: InputDecoration(
                  fillColor: Color(0xFFBAF9FF),
                  filled: true,
                  hintText: "Correo electrónico",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: tecPassword,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Color(0xFFBAF9FF),
                  filled: true,
                  hintText: "Contraseña",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: tecRepeatPassword,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Color(0xFFBAF9FF),
                  filled: true,
                  hintText: "Repita su contraseña",
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
                  TextButtonCustom(onPressed: onClickRegistrarse, text: "Registrarse"),
                  SizedBox(
                    width: 50,
                  ),
                  TextButtonCustom(onPressed: onClickCancelar, text: "Cancelar")
                ],
              )
            ],
          ),
        ),
        backgroundColor: Color(0xFFFEFFDE)
    );
  }

  void onClickRegistrarse() async {

    if (tecUser.text.isEmpty ||
        tecPassword.text.isEmpty ||
        tecRepeatPassword.text.isEmpty) {
      ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
        content: Text("Por favor, rellena todos los campos"),
        duration: Duration(seconds: 2),
      ));
    }

    if (tecPassword.text == tecRepeatPassword.text) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: tecUser.text,
          password: tecPassword.text,
        );

        Navigator.of(_context).pushNamed("/homeView");

        ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
          content: Text("¡Cuenta creada con exito!"),
          duration: Duration(seconds: 2),
        ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
            content: Text("Contraseña demasiado corta"),
            duration: Duration(seconds: 2),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(_context).showSnackBar(SnackBar(
            content: Text("La cuenta ya existe."),
            duration: Duration(seconds: 2),
          ));
        }
      } catch (e) {
        print(e);
      }
    } else if (tecPassword.text != tecRepeatPassword.text) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text("Las contraseñas no coinciden"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void onClickCancelar(){

    Navigator.of(_context).popAndPushNamed("/loginView");

  }

}