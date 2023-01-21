import 'package:flutter/material.dart';

//Provider for changing prefixIconColor of TextFormFields (determined by FocusNodes)
class TextFormFieldPrefixIconColorProvider extends ChangeNotifier {
  Color _messagePrefixIconColor = Colors.white70,
      _namePrefixIconColor = Colors.white70;

  Color get messagePrefixIconColor => _messagePrefixIconColor;
  Color get namePrefixIconColor => _namePrefixIconColor;

  set messagePrefixIconColor(Color prefixIconColor) {
    _messagePrefixIconColor = prefixIconColor;
    notifyListeners();
  }

  set namePrefixIconColor(Color prefixIconColor) {
    _namePrefixIconColor = prefixIconColor;
    notifyListeners();
  }
}
