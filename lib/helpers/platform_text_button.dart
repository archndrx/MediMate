import 'dart:io';

import 'package:flutter/material.dart';

class PlatfromTextButton extends StatelessWidget {
  final VoidCallback handler;
  final Widget buttonChild;
  final Color color;

  PlatfromTextButton({this.buttonChild, this.color, this.handler});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(this.color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        onPressed: this.handler,
        child: this.buttonChild,
      );
    } else {
      return Container();
    }
  }
}
