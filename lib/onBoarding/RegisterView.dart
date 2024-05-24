import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../animations/change_screen_animation.dart';
import '../components/center_widget/center_widget.dart';
import '../customViews/TextButtonCustom.dart';


class RegisterView extends StatefulWidget {
  static const String id = 'registerView';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with TickerProviderStateMixin {
  late BuildContext _context;

  final TextEditingController tecUser = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();
  final TextEditingController tecRepeatPassword = TextEditingController();

  @override
  void initState() {
    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: 3,
      loginItems: 0,
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
          _buildRegisterContent(context),
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

  Widget _buildRegisterContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          Text(
            "Registro World News",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 50),
          _inputField("Correo electrónico", Ionicons.mail_outline, tecUser),
          _inputField("Contraseña", Ionicons.lock_closed_outline, tecPassword, obscureText: true),
          _inputField("Repita su contraseña", Ionicons.lock_closed_outline, tecRepeatPassword, obscureText: true),
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
        TextButtonCustom(onPressed: onClickRegistrarse, text: "Registrarse"),
        SizedBox(width: 20),
        TextButtonCustom(onPressed: onClickCancelar, text: "Volver"),
      ],
    );
  }

  void onClickRegistrarse() async {
    if (tecPassword.text == tecRepeatPassword.text) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: tecUser.text,
          password: tecPassword.text,
        );
        Navigator.of(_context).pushNamed("/homeView");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden')),
      );
    }
  }

  void onClickCancelar() {
    Navigator.of(_context).popAndPushNamed("/loginMobile");
  }
}
