import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/center_widget/center_widget.dart';
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
          _buildContent(context),
        ],
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

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.blue,),
            ),
          ),
          TextField(
            controller: _apellidosController,
            decoration: InputDecoration(
              labelText: 'Apellidos',
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.blue,),
            ),
          ),
          TextField(
            controller: _edadController,
            decoration: InputDecoration(
              labelText: 'Edad',
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Colors.blue,),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateUser,
            child: Text('Guardar Cambios'),
          ),
        ],
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
