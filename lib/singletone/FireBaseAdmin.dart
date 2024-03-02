
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../fireStoreObjects/FbUsuario.dart';

class FirebaseAdmin {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Logearse
  Future<User?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser;
    } catch (e) {
      print("Error en inicio de sesión: $e");
      return null;
    }
  }

  // Cargar usuario
  Future<FbUsuario?> loadFbUsuario() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        var snapshot = await FirebaseFirestore.instance.collection('Usuarios').doc(currentUser.uid).get();
        return FbUsuario.fromFirestore(snapshot);
      } catch (e) {
        print('Error al cargar el usuario: $e');
      }
    }
    return null;
  }


}