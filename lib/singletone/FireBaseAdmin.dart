
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../fireStoreObjects/FbUsuario.dart';

class FirebaseAdmin {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener el usuario actualmente autenticado
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

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
  late FbUsuario fireBaseUser;
  // Cargar usuario
  Future<FbUsuario?> loadFbUsuario() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return null;
    }
    String uid = currentUser.uid;

    DocumentReference<FbUsuario> ref = db.collection("Usuarios").doc(uid).withConverter(
      fromFirestore: (snapshot, _) => FbUsuario.fromFirestore(snapshot, null),
      toFirestore: (user, _) => user.toFirestore(),
    );

    DocumentSnapshot<FbUsuario> docSnap = await ref.get();
    FbUsuario? user = docSnap.data();

    if (user == null) {
      return null;
    }

    return user;
  }



  // Actualizar usuario
  Future<void> updateUser(String id, String nombre, String apellidos, int edad) async {
    await FirebaseFirestore.instance.collection('Usuarios').doc(id).update({
      'nombre': nombre,
      'apellidos': apellidos,
      'edad': edad,
    });
  }

  // Agregar usuario a la BBDD
  Future<String> addUser(String nombre, String apellidos, int edad) async {
    try {
      var docRef = await FirebaseFirestore.instance.collection('Usuarios').add({
        'nombre': nombre,
        'apellidos': apellidos,
        'edad': edad,
      });
      return docRef.id; // Retorna el ID del documento creado
    } catch (e) {
      print('Error al añadir usuario a Firestore: $e');
      throw e;
    }
  }

}