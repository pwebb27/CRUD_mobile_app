import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key, required this.child, required this.linearGradient});

  final Widget child;
  final LinearGradient linearGradient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: BoxDecoration(gradient: linearGradient), child: child),
    );
  }
}
