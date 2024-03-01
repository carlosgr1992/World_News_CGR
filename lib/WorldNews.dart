import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_news/onBoarding/HomeView.dart';
import 'package:world_news/onBoarding/RegisterView.dart';

import 'onBoarding/LoginView.dart';

class WorldNews extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "World News",
      routes: {
        "/loginView": (context) => LoginView(),
        "/registerView": (context) => RegisterView(),
        "/homeView": (context) => HomeView(),
      },
      initialRoute: "/loginView",
    );
  }
}