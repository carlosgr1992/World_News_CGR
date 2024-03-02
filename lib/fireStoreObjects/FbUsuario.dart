import 'package:cloud_firestore/cloud_firestore.dart';

class FbUsuario {
  final String id;
  final String nombre;
  final String apellidos;
  final int edad;

  FbUsuario({
    this.id = '',
    required this.nombre,
    required this.apellidos,
    required this.edad,
  });

  factory FbUsuario.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data() ?? {}; //Usa un mapa vacío si no hay datos
    return FbUsuario(
      id: snapshot.id,
      nombre: data['nombre'] ?? "",
      apellidos: data['apellidos'] ?? "",
      edad: data['edad'] ?? 0,
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
