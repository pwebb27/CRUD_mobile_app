import 'package:flutter/material.dart';

//Provider for monitoring network connection
class ConnectivityProvider extends ChangeNotifier {
  bool _isNetworkOffline = false;

  bool get isNetworkOffline => _isNetworkOffline;

  set isNetworkOffline(bool isNetworkOffline){
    _isNetworkOffline = isNetworkOffline;
    notifyListeners();
  }
}
