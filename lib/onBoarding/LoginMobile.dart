import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../animations/change_screen_animation.dart';
import '../components/center_widget/center_widget.dart';
import '../customViews/TextButtonCustom.dart';
import '../fireStoreObjects/FbUsuario.dart';
import '../singletone/DataHolder.dart';

class LoginMobile extends StatefulWidget {
  static const String id = 'loginView';

  @override
  State<LoginMobile> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginMobile> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late BuildContext _context;

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
          SizedBox(height: 70),
          _inputField("Introduzca su correo electrónico", Ionicons.mail_outline, emailController),
          _inputField("Introduzca su contraseña", Ionicons.lock_closed_outline, passwordController, obscureText: true),
          SizedBox(height: 20),
          _actionButtons(),
          _accessFromPhoneText(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButtonCustom(onPressed: onClickLogin, text: "Login"),
        SizedBox(width: 20),
        TextButtonCustom(onPressed: onClickVolver, text: "Registrarse"),
      ],
    );
  }

  Widget _accessFromPhoneText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(_context).pushNamed("/loginView");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Ionicons.phone_portrait_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              "Acceder desde el teléfono",
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

  void onClickLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      FbUsuario? user = await DataHolder.firebaseAdmin.loadFbUsuario();
      if (user != null) {
        Navigator.of(context).popAndPushNamed("/homeView");
      } else {
        Navigator.of(context).popAndPushNamed("/registerDataUser");
      }
    } catch (e) {
      _showErrorDialog("Error al iniciar sesión: $e");
    }
  }

  void onClickVolver() {
    Navigator.of(_context).popAndPushNamed("/registerView");
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
}
