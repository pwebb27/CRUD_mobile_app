import 'package:flutter/cupertino.dart';

class FloatingActionButtonProvider extends ChangeNotifier{
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  set isVisible(bool isVisible){
    _isVisible = isVisible;
    notifyListeners();
  }
}