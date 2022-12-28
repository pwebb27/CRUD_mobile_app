import 'package:flutter/material.dart';

//Provider for checking if text resides inside available TextFormFields of DataEntryViewScreen
class ButtonTextProvider extends ChangeNotifier {
  bool _hasTextInFormFields = false;

  bool get hasTextInFormFields => _hasTextInFormFields;

  //Method for setting hasTextInFormFields based on whether all TextFormFields have text input
  void checkTextInFormFields(String messageText, String nameText) {
    (nameText != '' && messageText != '')
        ? _hasTextInFormFields = true
        : _hasTextInFormFields = false;
    notifyListeners();
  }
}
