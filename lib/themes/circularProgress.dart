import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class CircularIndicatorCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? CircularProgressIndicator()
        : CupertinoActivityIndicator();
  }
}
