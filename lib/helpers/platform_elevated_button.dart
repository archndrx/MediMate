import 'package:flutter/material.dart';

class PlatformElevatedButton extends StatelessWidget {
  final VoidCallback handler;
  final Widget buttonChild;
  final Color color;

  PlatformElevatedButton({this.buttonChild, this.color, this.handler});

  @override
  Widget build(BuildContext context) {
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
  }
}
