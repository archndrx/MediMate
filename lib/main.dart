import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Popins",
        primaryColor: Color.fromRGBO(7, 190, 200, 1),
        textTheme: TextTheme(
          displayLarge: ThemeData.light().textTheme.displayLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 38.0,
                fontFamily: "Popins",
              ),
          headlineSmall: ThemeData.light().textTheme.displayLarge.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
                fontFamily: "Popins",
              ),
          displaySmall: ThemeData.light().textTheme.displaySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                fontFamily: "Popins",
              ),
        ),
      ),
    );
  }
}
