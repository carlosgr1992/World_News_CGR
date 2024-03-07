import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_news/onBoarding/HomeView.dart';
import 'package:world_news/onBoarding/LoginMobile.dart';
import 'package:world_news/onBoarding/MuestraFavoritos.dart';
import 'package:world_news/onBoarding/RegisterDataUser.dart';
import 'package:world_news/onBoarding/RegisterView.dart';
import 'package:world_news/onBoarding/LoginView.dart';
import 'package:world_news/onBoarding/Splash.dart';

import 'onBoarding/DetalleNoticiaView.dart';

class WorldNews extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "World News",
      routes: {
        "/loginView": (context) => LoginView(),
        "/registerView": (context) => RegisterView(),
        "/homeView": (context) => HomeView(),
        "/splashView": (context) => Splash(),
        "/registerDataUser": (context) => RegisterDataUser(),
        '/detalleNoticiaView': (context) => DetalleNoticiaView(),
        '/favoritosView': (context) => MuestraFavoritos(),
        '/loginMobile': (context) => LoginMobile(),
      },
      initialRoute: "/splashView",
    );
  }
}
