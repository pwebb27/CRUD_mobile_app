// Dart imports:
import 'dart:async';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

// Project imports:
import 'package:crud_mobile_app/providers/DataEntryViewScreen/button_size_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/post_uploading_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_prefix_icon_color_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_text_provider.dart';
import 'package:crud_mobile_app/providers/ViewDataScreenProviders/FloatingActionButtonProvider.dart';
import 'package:crud_mobile_app/providers/connectivity_provider.dart';
import 'package:crud_mobile_app/providers/posts_stream_provider.dart';
import 'package:crud_mobile_app/screens/home_tabs_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TextFormFieldTextProvider()),
    ChangeNotifierProvider(create: (_) => ButtonSizeProvider()),
    ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
    ChangeNotifierProvider(
        create: (_) => TextFormFieldPrefixIconColorProvider()),
    ChangeNotifierProvider(create: (_) => PostUploadProvider()),
    ChangeNotifierProvider(create: (_) => PostsStreamProvider()),
    ChangeNotifierProvider(create: (_) => FloatingActionButtonProvider()),

  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late ConnectivityResult _connectionStatus;

  @override
  void initState() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      _connectionStatus = connectivityResult;
      _checkInternetConnectivity();
    });
    _checkInitialInternetConnectivity();
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    super.initState();
  }

  //Checks initial internet connection upon app load
  void _checkInitialInternetConnectivity() async {
    await Connectivity().checkConnectivity().then((connectivityResult) {
      _connectionStatus = connectivityResult;
      _checkInternetConnectivity();
    });
  }

  //Processes connection changes that occur at any point in application
  void _checkInternetConnectivity() {
    if (_connectionStatus == ConnectivityResult.none) {
      scaffoldMessengerKey.currentState!.clearSnackBars();
      context.read<ConnectivityProvider>().isNetworkOffline = true;
      scaffoldMessengerKey.currentState!
          .showSnackBar(_buildConnectivitySnackBar());
    } else {
      if ((_connectionStatus == ConnectivityResult.ethernet ||
              _connectionStatus == ConnectivityResult.mobile ||
              _connectionStatus == ConnectivityResult.wifi) &&
          context.read<ConnectivityProvider>().isNetworkOffline == true) {
        scaffoldMessengerKey.currentState!.clearSnackBars();
        context.read<ConnectivityProvider>().isNetworkOffline = false;
        scaffoldMessengerKey.currentState!
            .showSnackBar(_buildConnectivitySnackBar());
      }
    }
  }

  //Returns SnackBar for informing when internet is offline or when internet connection is restored to be displayed anywhere in app
  SnackBar _buildConnectivitySnackBar() {
    bool networkOffline = context.read<ConnectivityProvider>().isNetworkOffline;
    return SnackBar(
      duration: networkOffline
          ? //Infinite SnackBar if offline
          const Duration(days: 365)
          : const Duration(seconds: 4),
      backgroundColor: networkOffline ? Colors.red.shade800 : Colors.green,
      content: Row(
        children: [
          Icon(networkOffline ? Icons.wifi_off_rounded : Icons.wifi,
              color: Colors.white, size: 22),
          const SizedBox(width: 15),
          Text(
            networkOffline
                ? 'No Internet connection available'
                : 'Internet connected',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    //Application only operates in potrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Flutter Demo',
        theme: ThemeData(
            textTheme: const TextTheme(
                titleMedium:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                bodyMedium: TextStyle(fontSize: 15, color: Colors.black),
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
