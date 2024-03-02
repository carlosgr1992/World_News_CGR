import 'package:cloud_firestore/cloud_firestore.dart';

class FbUsuario {
  final String nombre;
  final String apellidos;
  final int edad;

  FbUsuario({
    required this.nombre,
    required this.apellidos,
    required this.edad,
  });

  factory FbUsuario.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,) {

    final data = snapshot.data();
    return FbUsuario(
      nombre: data?['nombre'] != null ? data!['nombre']: "",
      apellidos: data?['apellidos'] != null ? data!['apellidos']: "",
      edad: data?['edad'] != null ? data!['edad']: 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (nombre != null) "nombre": nombre,
      if (apellidos != null) "apellidos": apellidos,
      if (edad != null) "edad": edad,
    };
  }
}
