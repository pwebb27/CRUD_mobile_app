import 'package:crud_mobile_app/providers/button_text_provider.dart';
import 'package:crud_mobile_app/screens/home_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ButtonTextProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          errorColor: const Color.fromRGBO(139, 0, 0, 1),
          textTheme: const TextTheme(
              titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              bodyMedium: TextStyle(fontSize: 14),
              displayLarge: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
          primaryColor: Color.fromRGBO(0, 68, 102, 1)
        ),
        home: FutureBuilder(
            future: _firebaseApp,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeTabsScreen();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
