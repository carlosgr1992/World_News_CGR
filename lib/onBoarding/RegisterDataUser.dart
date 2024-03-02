import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/FireBaseAdmin.dart';

class RegisterDataUser extends StatefulWidget {
  final FbUsuario usuario;
  final String uid;

  RegisterDataUser({required this.usuario, required this.uid});

  @override
  _RegisterDataUserState createState() => _RegisterDataUserState();
}

class _RegisterDataUserState extends State<RegisterDataUser> {
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nombreController.text = widget.usuario.nombre;
    _apellidosController.text = widget.usuario.apellidos;
    _edadController.text = widget.usuario.edad.toString();
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
    var firebaseAdmin = FirebaseAdmin();
    await firebaseAdmin.updateUser(
      widget.uid,
      _nombreController.text,
      _apellidosController.text,
      int.parse(_edadController.text),
    );

    Navigator.of(context).popAndPushNamed("/homeView");
  }
}