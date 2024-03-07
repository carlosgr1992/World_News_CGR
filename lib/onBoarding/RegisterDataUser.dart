import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../fireStoreObjects/FbUsuario.dart';

class RegisterDataUser extends StatefulWidget {
  @override
  _RegisterDataUserState createState() => _RegisterDataUserState();
}

class _RegisterDataUserState extends State<RegisterDataUser> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late FbUsuario _usuario;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de usuario'),
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

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _db.collection("Usuarios").doc(user.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          _usuario = FbUsuario.fromFirestore(userSnapshot);
          _nombreController.text = _usuario.nombre ?? '';
          _apellidosController.text = _usuario.apellidos ?? '';
          _edadController.text = _usuario.edad?.toString() ?? '';
        });
      }
    }
  }

  void _updateUser() async {
    FbUsuario usuario = FbUsuario(
      nombre: _nombreController.text,
      apellidos: _apellidosController.text,
      edad: int.parse(_edadController.text),
    );

    String userUid = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection("Usuarios").doc(userUid).set(usuario.toFirestore());

    Navigator.of(context).popAndPushNamed("/homeView");
  }
}
