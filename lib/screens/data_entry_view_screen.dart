import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_text_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_prefix_icon_color_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:provider/provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/button_size_provider.dart';

class DataEntryViewScreen extends StatefulWidget {
  const DataEntryViewScreen({super.key});

  @override
  State<DataEntryViewScreen> createState() => _DataEntryViewScreenState();
}

enum FieldDataType { name, message }

class _DataEntryViewScreenState extends State<DataEntryViewScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final DatabaseReference _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('messages');
  late final AnimationController _buttonAnimationController;

  //Controllers for monitoring text input of form's TextFormFields
  final TextEditingController nameTextFormController = TextEditingController();
  final TextEditingController messageTextFormController =
      TextEditingController();

  final FocusNode _messageTextFormFieldFocusNode = FocusNode();
  final FocusNode _nameTextFormFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    //Animation used for changing size of button based on tap inputs
    _buttonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 50),
        vsync: this,
        lowerBound: 0,
        upperBound: .05)
      ..addListener(() {
        context.read<ButtonSizeProvider>().buttonScale =
            1 + _buttonAnimationController.value;
      });
    messageTextFormController.addListener(_textFormFieldsTextListener);
    nameTextFormController.addListener(_textFormFieldsTextListener);

    _nameTextFormFieldFocusNode.addListener(() {
      (_nameTextFormFieldFocusNode.hasFocus)
          //Change icon white color if focused
          ? context
              .read<TextFormFieldPrefixIconColorProvider>()
              .namePrefixIconColor = Colors.white
          : () {
              //Otherwise change to white70
              context
                  .read<TextFormFieldPrefixIconColorProvider>()
                  .namePrefixIconColor = Colors.white70;
              //Always shift focus to message TextFormField after name TextFormField
              _nameTextFormFieldFocusNode.nextFocus();
            };
    });

    _messageTextFormFieldFocusNode.addListener(() {
      (_messageTextFormFieldFocusNode.hasFocus)
          //Change icon white color if focused
          ? context
              .read<TextFormFieldPrefixIconColorProvider>()
              .messagePrefixIconColor = Colors.white
          : () {
              context
                  //Otherwise change to white70
                  .read<TextFormFieldPrefixIconColorProvider>()
                  .messagePrefixIconColor = Colors.white70;
              (nameTextFormController.text == '')
                  //Go back to name TextFormField from message TextFormField if no text entered
                  ? FocusScope.of(context).previousFocus()
                  //Otherwise hide keyboard
                  : FocusScope.of(context).unfocus();
            };
    });
  }

  void _textFormFieldsTextListener() {
    context.read<TextFormFieldTextProvider>().checkTextInFormFields(
        messageTextFormController.text, nameTextFormController.text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                Scaffold.of(context).appBarMaxHeight!.toDouble(),
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromRGBO(2, 86, 122, 1), Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Column(children: [
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
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
                              offset: Offset(8.0, 8.0),
                              blurRadius: 45.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ]),
                        ))
                      ]),
                )),
            Expanded(
              flex: 3,
              child: Column(children: [
                const SizedBox(height: 15),
                ListView(shrinkWrap: true, children: [
                  _buildOpacityAndPaddingAnimation(
                      child: _buildFormField(FieldDataType.name)),
                  _buildOpacityAndPaddingAnimation(
                      child: _buildFormField(FieldDataType.message))
                ]),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 25),
                  child: _buildOpacityAndPaddingAnimation(
                      child: _buildSubmitButton()),
                ),
              ]),
            ),
          ])),
    );
  }

  //Returns opacity and padding animation used for widgets in widget tree upon initial app load
  Widget _buildOpacityAndPaddingAnimation({required Widget child}) =>
      TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) => Padding(
                padding: EdgeInsets.only(top: 10 - (value * 10)),
                child: Opacity(opacity: value, child: child),
              ),
          child: child);

  Widget _buildFormField(FieldDataType fieldDatatype) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 5),
      child: TextFormField(
        focusNode: fieldDatatype == FieldDataType.message
            ? _messageTextFormFieldFocusNode
            : _nameTextFormFieldFocusNode,
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: fieldDatatype == FieldDataType.message
            ? messageTextFormController
            : nameTextFormController,
        //Name keyboard action always shows next line symbol
        textInputAction: fieldDatatype == FieldDataType.name
            ? TextInputAction.next
            // Message keyboard action shows previous line symbol if name field empty
            : nameTextFormController.text == ''
                ? TextInputAction.previous
                : TextInputAction.done,
        cursorColor: Colors.white,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            isDense: true,
            prefixIcon: fieldDatatype == FieldDataType.message
                ? Icon(Icons.message,
                    color: context
                        .watch<TextFormFieldPrefixIconColorProvider>()
                        .messagePrefixIconColor)
                : Icon(Icons.person,
                    color: context
                        .watch<TextFormFieldPrefixIconColorProvider>()
                        .namePrefixIconColor),
            labelStyle: const TextStyle(color: Colors.white70),
            floatingLabelStyle: const TextStyle(color: Colors.white),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 1.5, color: Colors.white70),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 2.5, color: Colors.white),
            ),
            alignLabelWithHint: true,
            labelText:
                fieldDatatype == FieldDataType.message ? 'Message' : 'Name'),
      ),
    );
  }

  Widget _buildSubmitButton() => Transform.scale(
        scale: context.watch<ButtonSizeProvider>().buttonScale,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: InkWell(
              borderRadius: BorderRadius.circular(10),
              //Increase size of button on tap down
              onTapDown: ((_) => _buttonAnimationController.forward()),
              //Decrease size of button on tap up and tap cancel
              onTapCancel: () => _buttonAnimationController.reverse(),
              onTapUp: (_) {
                _buttonAnimationController.reverse();
                if (context
                    .read<TextFormFieldTextProvider>()
                    .hasTextInFormFields) {
                  _postNameAndMessage();
                }
              },
              child: Container(
                height: 60,
                width: 200,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: !context
                                .watch<TextFormFieldTextProvider>()
                                .hasTextInFormFields
                            ? Colors.grey.shade500
                            : Colors.black),
                  ),
                ),
              )),
        ),
      );

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Row(
          children: const [
            Icon(Icons.message, color: Colors.white, size: 18),
            SizedBox(width: 15),
            Text(
              'Message Posted',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _postNameAndMessage() {
    _crudDatabaseReference.push().set({
      'name': nameTextFormController.text,
      'message': messageTextFormController.text,
    });
    nameTextFormController.clear();
    messageTextFormController.clear();
    _showToast(context);
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    nameTextFormController.dispose();
    messageTextFormController.dispose();
    super.dispose();
  }
}

// class MyPainter extends CustomPainter{
//   class BluePainter extends CustomPainter{
//     @override
//     void paint(Canvas canvas, Size size){
//       final height = size.height;
//       final width = size.width;
//       Paint paint = Paint();

//       Path lineBackground = Path();
//       lineBackground.moveTo(0, height*.2); 

//     }
//     @override
//     bool shouldRepaint(CustomPainter() oldDelegate){
//       return oldDelegate !=this;
//     }
//   }
// }

