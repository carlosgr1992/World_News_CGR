import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../customViews/TextButtonCustom.dart';
import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/DataHolder.dart';

class LoginMobile extends StatefulWidget {
  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  late BuildContext _context;
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Login Móvil"),
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
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                fillColor: Color(0xFFBAF9FF),
                filled: true,
                hintText: "Introduzca su número de teléfono",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (verificationId != null)
              TextField(
                controller: pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: Color(0xFFBAF9FF),
                  filled: true,
                  hintText: "Introduzca el código de verificación",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButtonCustom(onPressed: solicitarCodigo, text: "Solicitar código"),
                SizedBox(width: 20),
                TextButtonCustom(onPressed: onClickLogin, text: "Login"),
                SizedBox(width: 20),
                TextButtonCustom(onPressed: onClickVolver, text: "Volver"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void solicitarCodigo() async {
    String phoneNumber = phoneNumberController.text;
    if (phoneNumber.isNotEmpty) {
      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificacionCompletada,
          verificationFailed: verificacionFallida,
          codeSent: codigoEnviado,
          codeAutoRetrievalTimeout: tiempoDeEsperaAcabado,
        );
      } catch (e) {
        print("Error al generar el código SMS: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Se produjo un error al generar el código SMS. Por favor, inténtelo de nuevo más tarde."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Por favor, introduzca un número de teléfono válido."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void verificacionCompletada(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).popAndPushNamed("/homeView");
    } catch (e) {
      print("Error al completar la verificación: $e");
    }
  }

  void verificacionFallida(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      print('El número de teléfono proporcionado no es válido.');
    } else {
      print('Error de verificación del número de teléfono: ${exception.message}');
    }
  }

  void codigoEnviado(String verificationId, int? resendToken) {
    setState(() {
      this.verificationId = verificationId;
    });
  }

  void tiempoDeEsperaAcabado(String verificationId) {
    // Este método se llama cuando se acaba el tiempo de espera para introducir el código de verificación
  }

  void onClickVolver() {
    Navigator.of(_context).popAndPushNamed("/loginView");
  }

  void onClickLogin() async {
    String verificationCode = pinController.text;
    if (verificationCode.isNotEmpty) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: verificationCode);
        await FirebaseAuth.instance.signInWithCredential(credential);

        FbUsuario? user = await DataHolder.firebaseAdmin.loadFbUsuario();
        if (user != null) {
          Navigator.of(context).popAndPushNamed("/homeView");
        } else {
          Navigator.of(context).popAndPushNamed("/registerDataUser");
        }
      } catch (e) {
        print("Error al iniciar sesión con el código de verificación: $e");
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Por favor, introduzca el código de verificación."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

}
