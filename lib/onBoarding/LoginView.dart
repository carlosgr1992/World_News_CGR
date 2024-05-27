import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../animations/change_screen_animation.dart';
import '../components/center_widget/center_widget.dart';
import '../customViews/TextButtonCustom.dart';
import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/DataHolder.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  late BuildContext _context;
  String? verificationId;

  @override
  void initState() {
    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: 0,
      loginItems: 2,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
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
          _buildLoginContent(context),
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

  Widget _buildLoginContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          Text(
            "World News",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 80),
          _inputField("Introduzca su número de teléfono", Ionicons.phone_portrait_outline, phoneNumberController),
          if (verificationId != null)
            _inputField("Introduzca el código de verificación", Ionicons.lock_closed_outline, pinController, obscureText: true),
          SizedBox(height: 20),
          _actionButtons(),
        ],
      ),
    );
  }

  Widget _inputField(String hint, IconData iconData, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            obscureText: obscureText,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
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
        _accessFromPhoneText(),
      ],
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
        _showErrorDialog("Error al generar el código SMS: $e");
      }
    } else {
      _showErrorDialog("Por favor, introduzca un número de teléfono válido.");
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

  void tiempoDeEsperaAcabado(String verificationId) {}

  void onClickVolver() {
    Navigator.of(_context).popAndPushNamed("/loginMobile");
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
      _showErrorDialog("Por favor, introduzca el código de verificación.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
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

  Widget _accessFromPhoneText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(_context).pushNamed("/loginMobile");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Ionicons.at, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              "Acceso correo electrónico",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
