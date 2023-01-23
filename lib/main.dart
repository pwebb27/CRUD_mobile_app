import 'dart:async';

import 'package:crud_mobile_app/providers/DataEntryViewScreen/button_size_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_text_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_prefix_icon_color_provider.dart';
import 'package:crud_mobile_app/screens/home_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TextFormFieldTextProvider()),
    ChangeNotifierProvider(create: (_) => ButtonSizeProvider()),
    ChangeNotifierProvider(
        create: (_) => TextFormFieldPrefixIconColorProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();

  late StreamSubscription<ConnectivityResult> subscription;

  late ConnectivityResult? connectionStatus;

  @override
  void initState() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        connectionStatus = result;
        checkInternetConnectivity();
      });
    });
    checkInitialConnectivity();
    super.initState();
  }

  void checkInitialConnectivity() async {
    await Connectivity().checkConnectivity().then((result) {
      connectionStatus = result;
      checkInternetConnectivity();
    });
  }

  void checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none ||
        connectionStatus == null) {
      _messangerKey.currentState!.showSnackBar(
        SnackBar(
          duration: Duration(days: 365),
          backgroundColor: Colors.blue,
          content: Row(
            children: const [
              Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_sharp,
                  color: Colors.white, size: 18),
              SizedBox(width: 15),
              Text(
                'Network Offline',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    } else {
      _messangerKey.currentState!.clearSnackBars();
    }
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
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
            primaryColor: const Color.fromRGBO(103, 154, 175, 1)),
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
