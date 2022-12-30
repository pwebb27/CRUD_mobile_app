import 'package:crud_mobile_app/providers/DataEntryViewScreen/button_size_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_text_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_prefix_icon_color_provider.dart';
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
    ChangeNotifierProvider(create: (_) => TextFormFieldTextProvider()),
    ChangeNotifierProvider(create: (_) => ButtonSizeProvider()),
        ChangeNotifierProvider(create: (_) => TextFormFieldPrefixIconColorProvider()),


  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            textTheme: const TextTheme(
                titleMedium:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                bodyMedium: TextStyle(fontSize: 14),
                displayLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )),
            primaryColor: const Color.fromRGBO(181,81,13,1)),
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
