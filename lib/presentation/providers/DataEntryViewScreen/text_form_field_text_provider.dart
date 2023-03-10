// Flutter imports:
import 'package:flutter/material.dart';

//Provider for checking if text resides inside available TextFormFields (used for submit button)
class TextFormFieldTextProvider extends ChangeNotifier {
  bool _hasTextInFormFields = false;

  bool get hasTextInFormFields => _hasTextInFormFields;

  //Set hasTextInFormFields based on whether both TextFormFields have text input
  void checkTextInFormFields(String messageText, String nameText) {
    (nameText != '' && messageText != '')
        ? _hasTextInFormFields = true
        : _hasTextInFormFields = false;
    notifyListeners();
  }
}
