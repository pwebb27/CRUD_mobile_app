import 'package:flutter/material.dart';

//Provider for changing color inside submit button of DataEntryViewScreen
class ButtonSizeProvider extends ChangeNotifier {
  double _buttonScale = 1;

  double get buttonScale => _buttonScale;

  set buttonScale(double buttonScale){
    _buttonScale = buttonScale;
    notifyListeners();
  }
}
