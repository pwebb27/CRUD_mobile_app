// Flutter imports:
import 'package:flutter/material.dart';

//Provider for changing size of button (based on user tap inputs)
class ButtonSizeProvider extends ChangeNotifier {
  double _buttonScale = 1;

  double get buttonScale => _buttonScale;

  set buttonScale(double buttonScale){
    _buttonScale = buttonScale;
    notifyListeners();
  }
}
