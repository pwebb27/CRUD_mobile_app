import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_text_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/text_form_field_prefix_icon_color_provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/post_uploading_provider.dart';
import 'package:crud_mobile_app/providers/connectivity_provider.dart';
import 'package:crud_mobile_app/providers/posts_stream_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:provider/provider.dart';
import 'package:crud_mobile_app/providers/DataEntryViewScreen/button_size_provider.dart';

class DataEntryViewScreen extends StatefulWidget {
  const DataEntryViewScreen({super.key});

  @override
  State<DataEntryViewScreen> createState() => _DataEntryViewScreenState();
}

//Enum used for determining TextFormField type (used for buildTextFormFieldInputDecoration method)
enum FieldDataType { name, message }

class _DataEntryViewScreenState extends State<DataEntryViewScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final DatabaseReference _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('posts');
  late final AnimationController _buttonAnimationController;

  //For monitoring text input of TextFormFields
  final TextEditingController nameTextFormFieldController =
          TextEditingController(),
      messageTextFormFieldController = TextEditingController();

  final FocusNode _messageTextFormFieldFocusNode = FocusNode(),
      _nameTextFormFieldFocusNode = FocusNode();

  final _toast = FToast();

  @override
  void initState() {
    super.initState();
    //For changing size of button based on tap inputs
    _buttonAnimationController = AnimationController(
        duration: const Duration(milliseconds: 50),
        vsync: this,
        lowerBound: 0,
        upperBound: .05)
      ..addListener(() {
        context.read<ButtonSizeProvider>().buttonScale =
            1 + _buttonAnimationController.value;
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      PostsStreamProvider();
    });

    _toast.init(context);
    messageTextFormFieldController.addListener(_textEditingControllersListener);
    nameTextFormFieldController.addListener(_textEditingControllersListener);

    _nameTextFormFieldFocusNode.addListener(() {
      if (_nameTextFormFieldFocusNode.hasFocus) {
        //Make icon white if in focus
        context
            .read<TextFormFieldPrefixIconColorProvider>()
            .namePrefixIconColor = Colors.white;
      } else {
        //Otherwise icon is white70
        context
            .read<TextFormFieldPrefixIconColorProvider>()
            .namePrefixIconColor = Colors.white70;
      }
    });

    _messageTextFormFieldFocusNode.addListener(() {
      if (_messageTextFormFieldFocusNode.hasFocus) {
        //Make icon white if in focus
        context
            .read<TextFormFieldPrefixIconColorProvider>()
            .messagePrefixIconColor = Colors.white;
      } else {
        context
            //Otherwise icon is white70
            .read<TextFormFieldPrefixIconColorProvider>()
            .messagePrefixIconColor = Colors.white70;
      }
    });
  }

  void _textEditingControllersListener() {
    context.read<TextFormFieldTextProvider>().checkTextInFormFields(
        messageTextFormFieldController.text, nameTextFormFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color.fromRGBO(2, 86, 122, 1), Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(children: [
            SizedBox(
                height: (MediaQuery.of(context).size.height -
                        Scaffold.of(context).appBarMaxHeight!.toDouble()) *
                    .4,
                child: CustomPaint(
                  foregroundPainter: MyPainter(),
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
                  ),
                )),
            Column(children: [
              const SizedBox(height: 15),
              _buildOpacityAndPaddingAnimation(
                  child: _buildNameTextFormField()),
              _buildOpacityAndPaddingAnimation(
                  child: _buildMessageTextFormField()),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 25),
                child: _buildOpacityAndPaddingAnimation(
                    child: _buildSubmitButton()),
              ),
              //Show circular progress indicator below submit button if post upload is delayed
              if (context.watch<PostUploadProvider>().isPostUploadDelayed)
                Column(children: [
                  const SizedBox(height: 12),
                  SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 2,
                      ))
                ])
            ]),
          ]),
        ),
      ),
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

  Widget _buildNameTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 20, right: 20),
      child: TextFormField(
          focusNode: _nameTextFormFieldFocusNode,
          style: const TextStyle(
            color: Colors.white,
          ),
          controller: nameTextFormFieldController,
          textInputAction: TextInputAction.next,
          cursorColor: Colors.white,
          textAlignVertical: TextAlignVertical.center,
          decoration: buildTextFormFieldInputDecoration(FieldDataType.name)),
    );
  }

  Widget _buildMessageTextFormField() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 20, right: 20),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        maxLength: null,
        maxLines: null,
        focusNode: _messageTextFormFieldFocusNode,
        style: const TextStyle(
          color: Colors.white,
        ),
        controller: messageTextFormFieldController,
        textInputAction: TextInputAction.newline,
        cursorColor: Colors.white,
        textAlignVertical: TextAlignVertical.center,
        decoration: buildTextFormFieldInputDecoration(FieldDataType.message),
      ),
    );
  }

  //Returns InputDecoration used for both TextFormFields
  InputDecoration buildTextFormFieldInputDecoration(
      FieldDataType fieldDataType) {
    return InputDecoration(
        isDense: true,
        prefixIcon: fieldDataType == FieldDataType.message
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
        labelText: fieldDataType == FieldDataType.message ? 'Message' : 'Name');
  }

  Widget _buildSubmitButton() => Transform.scale(
        scale: context.watch<ButtonSizeProvider>().buttonScale,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color:
              !context.watch<TextFormFieldTextProvider>().hasTextInFormFields ||
                      context.watch<ConnectivityProvider>().isNetworkOffline ||
                      context.watch<PostUploadProvider>().isPostUploading
                  ? Colors.grey.shade300
                  : Colors.white,
          child: InkWell(
              borderRadius: BorderRadius.circular(10),
              //Increase size of button on tap down
              onTapDown: ((_) => _buttonAnimationController.forward()),
              //Decrease size of button on tap up and tap cancel
              onTapCancel: () => _buttonAnimationController.reverse(),
              onTapUp: (_) async {
                _buttonAnimationController.reverse();
                if (context
                        .read<TextFormFieldTextProvider>()
                        .hasTextInFormFields &&
                    !context.read<ConnectivityProvider>().isNetworkOffline &&
                    !context.read<PostUploadProvider>().isPostUploading) {
                  context.read<PostUploadProvider>().isPostUploading = true;
                  Future.delayed(const Duration(seconds: 2)).then((_) {
                    if (context.read<PostUploadProvider>().isPostUploading) {
                      context.read<PostUploadProvider>().isPostUploadDelayed =
                          true;
                    }
                  });
                  await _crudDatabaseReference
                      .push()
                      .set({
                        'name': nameTextFormFieldController.text,
                        'message': messageTextFormFieldController.text.trim(),
                        'timestamp': ServerValue.timestamp
                      })
                      .timeout(const Duration(seconds: 10),
                          onTimeout: _handlePostTimeoutOrError)
                      .onError((_, __) {
                        _handlePostTimeoutOrError();
                      })
                      .then((_) {
                        context.read<PostUploadProvider>().isPostUploading =
                            false;
                        //Stop CircularProgressIndicator
                        context.read<PostUploadProvider>().isPostUploadDelayed =
                            false;
                        nameTextFormFieldController.clear();
                        messageTextFormFieldController.clear();
                        FocusScope.of(context).unfocus();
                        _toast.showToast(
                            child: _buildSuccessfulPostToast(),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: const Duration(seconds: 4));
                      });
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
                                    .hasTextInFormFields ||
                                context
                                    .watch<ConnectivityProvider>()
                                    .isNetworkOffline ||
                                context
                                    .watch<PostUploadProvider>()
                                    .isPostUploading
                            ? Colors.grey.shade500
                            : Colors.grey.shade800),
                  ),
                ),
              )),
        ),
      );
  void _handlePostTimeoutOrError() {
    context.read<PostUploadProvider>().isPostUploading == false;
    context.read<PostUploadProvider>().isPostUploadDelayed = false;
    _buildUnsuccessfulPostToast();
  }

  Widget _buildSuccessfulPostToast() => Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.grey.shade600.withOpacity(.5),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check_circle, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  'Message posted',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      );

  Widget _buildUnsuccessfulPostToast() => Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.red.shade600.withOpacity(.8),
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.info_outline, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  'An error occurred. Please try again',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
      );

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    nameTextFormFieldController.dispose();
    messageTextFormFieldController.dispose();
    super.dispose();
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path lineBackground = Path();
    lineBackground.moveTo(0, 0);
    lineBackground.lineTo(height * .15, 0);
    lineBackground.lineTo(height * .20, 0);
    lineBackground.lineTo(0, height * .20);

    double multiplier = 3;
    lineBackground.moveTo(0, (height * .30));
    lineBackground.lineTo((height * .30), 0);
    lineBackground.lineTo((height * .6), 0);
    lineBackground.lineTo(0, (height * .6));

    paint.color = Color.fromRGBO(118, 164, 183, 1);
    canvas.drawPath(lineBackground, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
