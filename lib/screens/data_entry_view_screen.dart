import 'package:crud_mobile_app/providers/button_text_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:provider/provider.dart';
import 'package:crud_mobile_app/providers/button_size_provider.dart';

class DataEntryViewScreen extends StatefulWidget {
  const DataEntryViewScreen({super.key});

  @override
  State<DataEntryViewScreen> createState() => _DataEntryViewScreenState();
}

enum FieldDataType { name, message }

class _DataEntryViewScreenState extends State<DataEntryViewScreen>
    with TickerProviderStateMixin {
  String _nameEntry = '';
  String _messageEntry = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseReference _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('messages');
  final TextEditingController nameTextFormController = TextEditingController();
  final TextEditingController messageTextFormController =
      TextEditingController();
  late final AnimationController _buttonAnimationController;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 50),
        vsync: this,
        lowerBound: 0,
        upperBound: .1)
      ..addListener(() {
        context.read<ButtonSizeProvider>().buttonScale =
            1 + _buttonAnimationController.value;
      });
    messageTextFormController.addListener(_buttonListener);
    nameTextFormController.addListener(_buttonListener);
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
            ),
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
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 119, 179, 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildOpacityAndPaddingAnimation(
                            child: SimpleShadow(
                              opacity: .6,
                              color: Colors.black,
                              offset: const Offset(3, 3),
                              sigma: 7,
                              child: Image.asset(
                                'assets/images/flutter-logo.png',
                                height: 95,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          _buildOpacityAndPaddingAnimation(
                              child: Text(
                            'Enter your name and message',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(shadows: <Shadow>[
                              const Shadow(
                                offset: Offset(10.0, 10.0),
                                blurRadius: 40.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ]),
                          ))
                        ]),
                  )),
              Expanded(
                flex: 3,
                child: Column(children: [
                  const SizedBox(height: 30),
                  Form(
                      key: _formKey,
                      child: ListView(shrinkWrap: true, children: [
                        _buildOpacityAndPaddingAnimation(
                            child: _buildFormField(FieldDataType.name)),
                        _buildOpacityAndPaddingAnimation(
                            child: _buildFormField(FieldDataType.message))
                      ])),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 25),
                    child: _buildOpacityAndPaddingAnimation(
                        child: _buildSubmitButton()),
                  )
                ]),
              ),
            ])),
      );

  Widget _buildOpacityAndPaddingAnimation({required Widget child}) =>
      TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) => Padding(
                padding: EdgeInsets.only(top: 10 - (value * 10)),
                child: Opacity(opacity: value, child: child),
              ),
          child: child);

  Widget _buildFormField(FieldDataType fieldDatatype) => Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 5),
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          onChanged: (textFormText) {
            fieldDatatype == FieldDataType.message
                ? _messageEntry = textFormText
                : _nameEntry = textFormText;
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

  Widget _buildSubmitButton() => GestureDetector(
        onTapDown: ((details) {
          _buttonAnimationController.forward();
          if (_messageEntry.isNotEmpty && _nameEntry.isNotEmpty) {
            final Map<String, dynamic> post = {
              'name': _nameEntry,
              'message': _messageEntry,
            };
            _crudDatabaseReference.push().set(post);
            nameTextFormController.clear();
            messageTextFormController.clear();
            _messageEntry = _nameEntry = '';
          }
        }),
        onTapCancel: () {
          _buttonAnimationController.reverse();
        },
        onTapUp: (details) => _buttonAnimationController.reverse(),
        child: Transform.scale(
            scale: context.watch<ButtonSizeProvider>().buttonScale,
            child: Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context
                                  .watch<ButtonTextProvider>()
                                  .isTextInsideFields ==
                              false
                          ? Colors.grey.shade500
                          : Colors.black),
                ),
              ),
            )),
      );

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    nameTextFormController.dispose();
    messageTextFormController.dispose();
    super.dispose();
  }
}