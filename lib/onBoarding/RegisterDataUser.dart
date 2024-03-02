import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';

class RegisterDataUser extends StatefulWidget {
  @override
  _RegisterDataUserState createState() => _RegisterDataUserState();
}

class _RegisterDataUserState extends State<RegisterDataUser> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      backgroundColor: Color(0xFFDFFCFF),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: _edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _updateUser,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUser() async {

    FbUsuario usuario = FbUsuario(nombre: _nombreController.text,apellidos: _apellidosController.text,edad: int.parse(_edadController.text));

    String userUid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(userUid).set(usuario.toFirestore());

    Navigator.of(context).popAndPushNamed("/homeView");
  }
}
