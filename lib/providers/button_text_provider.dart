import 'package:flutter/material.dart';

//Provider for changing color inside submit button of DataEntryViewScreen
class ButtonTextProvider extends ChangeNotifier {
  bool _isTextInsideFields = false;

  bool get isTextInsideFields => _isTextInsideFields;

  void determineIfFieldsHaveText(
      String messageText,
      String nameText) {
    (nameText !='' && messageText!='')
        ? _isTextInsideFields = true
        : _isTextInsideFields = false;
    notifyListeners();
  }
}
