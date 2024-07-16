import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:provider/provider.dart';
import 'package:jahnhalle/pages/home_page.dart';
import 'package:jahnhalle/themes/app_theme.dart';
import 'firebase_options.dart'; // Diese Datei sollte generiert und korrekt konfiguriert sein

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Firebase initialized");
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
        debugShowCheckedModeBanner: false, // Debug-Banner entfernen
        theme: AppTheme.lightTheme, // Benutzerdefiniertes Thema verwenden
        home: const MyHomePage(title: ''), // HomePage mit Titel
      ),
    );
  }
}
