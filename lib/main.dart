import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/pages/mohsim/splash.dart';
import 'package:jahnhalle/pages/mohsim/utils/sp.dart';
import 'package:jahnhalle/utils/dimension.dart';
import 'package:provider/provider.dart';

import 'package:jahnhalle/themes/app_theme.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/mohsim/login.dart';
import 'pages/mohsim/main_dashboard.dart'; // Diese Datei sollte generiert und korrekt konfiguriert sein

Dimensions dimensions = Dimensions(height: 600, width: 480);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SP.i.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => Cart()), // Cart Provider hinzufügen
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: kDebugMode, // Debug-Banner entfernen
        theme: AppTheme.lightTheme, // Benutzerdefiniertes Thema verwenden
        // home: const MyHomePage(title: ''), // HomePage mit Titel
        home: Builder(builder: (context) {
          dimensions = Dimensions(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width);
          // return const MainDashboard();
          // return const LoginScreen();
          return const SplashScreen();
        }),
      ),
    );
  }
}
