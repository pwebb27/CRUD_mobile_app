import 'package:crud_mobile_app/providers/button_text_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:provider/provider.dart';

class DataEntryViewScreen extends StatefulWidget {
  const DataEntryViewScreen({super.key});

  @override
  State<DataEntryViewScreen> createState() => _DataEntryViewScreenState();
}

enum FieldDataType { name, message }

class _DataEntryViewScreenState extends State<DataEntryViewScreen> {
  String _name = '';
  String _message = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('messages');
  late final TextEditingController nameTextFormController;
  late final TextEditingController messageTextFormController;

  @override
  void initState() {
    messageTextFormController = TextEditingController();
    nameTextFormController = TextEditingController()
      ..addListener(_buttonListener);
    messageTextFormController.addListener(_buttonListener);

    super.initState();
  }

  //Checks if button has text
  void _buttonListener() {
    context.read<ButtonTextProvider>().determineIfFieldsHaveText(
        messageTextFormController.text, nameTextFormController.text);
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight!.toDouble(),
                maxWidth: MediaQuery.of(context).size.width),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(0, 68, 102, 1), Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Column(children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Column(children: <Widget>[
                      SimpleShadow(
                        opacity: .6,
                        color: Colors.black,
                        offset: const Offset(3, 3),
                        sigma: 7,
                        child: Image.asset(
                          'assets/images/flutter-logo.png',
                          height: 95,
                        ),
                      ),
                      Text(
                        'Enter your name and message',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ]),
                  )),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Form(
                          key: _formKey,
                          child: ListView(shrinkWrap: true, children: [
                            _buildFormField(FieldDataType.name),
                            _buildFormField(FieldDataType.message)
                          ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, top: 25),
                      child: _buildSubmitButton(),
                    )
                  ]),
                ),
              ),
            ])),
      );

  Widget _buildFormField(FieldDataType fieldDatatype) => Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 5),
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          onChanged: (textFormText) {
            fieldDatatype == FieldDataType.message
                ? _message = textFormText
                : _name = textFormText;
          },
          controller: fieldDatatype == FieldDataType.message
              ? messageTextFormController
              : nameTextFormController,
          cursorColor: Colors.white,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              isDense: true,
              prefixIcon: fieldDatatype == FieldDataType.message
                  ? const Icon(
                      Icons.message,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Colors.white70),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
              alignLabelWithHint: true,
              labelText:
                  fieldDatatype == FieldDataType.message ? 'Message' : 'Name'),
        ),
      );

  Widget _buildSubmitButton() => ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
      onPressed: () {
        if (_message.isNotEmpty && _name.isNotEmpty) {
          final Map<String, dynamic> post = {
            'name': _name,
            'message': _message,
          };
          _crudDatabaseReference.push().set(post);
          nameTextFormController.clear();
          messageTextFormController.clear();
          _message = _name = '';
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        child: Text(
          'Submit',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.watch<ButtonTextProvider>().isTextInsideFields ==
                      false
                  ? Colors.grey.shade500
                  : Colors.black),
        ),
      ));

  @override
  void dispose() {
    nameTextFormController.removeListener(_buttonListener);
    messageTextFormController.removeListener(_buttonListener);
    nameTextFormController.dispose();
    messageTextFormController.dispose();
    super.dispose();
  }
}
