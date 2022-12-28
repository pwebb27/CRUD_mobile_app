import 'package:flutter/material.dart';

//Provider for changing color inside submit button of DataEntryViewScreen
class ButtonTextProvider extends ChangeNotifier {
  bool _hasTextInFormFields = false;

  bool get hasTextInFormFields => _hasTextInFormFields;

  void checkTextInFormFields(
      String messageText,
      String nameText) {
    (nameText !='' && messageText!='')
        ? _hasTextInFormFields = true
        : _hasTextInFormFields = false;
    notifyListeners();
  }
}
