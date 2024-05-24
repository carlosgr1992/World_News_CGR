import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Theme/ThemeNotifier.dart';
import 'firebase_options.dart';
import 'WorldNews.dart';
import 'firebase_options.dart';
import 'onBoarding/ConfiguracionView.dart';
import 'onBoarding/DetalleNoticiaView.dart';
import 'onBoarding/HomeView.dart';
// Importa solo desde la ubicación correcta
import 'onBoarding/LoginView.dart';
import 'onBoarding/LoginMobile.dart';
import 'onBoarding/MuestraFavoritos.dart';
import 'onBoarding/RegisterDataUser.dart';
import 'onBoarding/RegisterView.dart';
import 'onBoarding/Splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeNotifier,
      builder: (context, theme, _) {
        return MaterialApp(
          title: "World News",
          theme: theme,
          routes: {
            "/loginView": (context) => LoginView(),
            "/registerView": (context) => RegisterView(),
            "/homeView": (context) => HomeView(),
            "/splashView": (context) => Splash(),
            "/registerDataUser": (context) => RegisterDataUser(),
            '/detalleNoticiaView': (context) => DetalleNoticiaView(),
            '/favoritosView': (context) => MuestraFavoritos(),
            '/loginMobile': (context) => LoginMobile(),
            '/configuracionView': (context) => ConfiguracionView(),
          },
          initialRoute: "/loginMobile",
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
