import 'package:flutter/material.dart';
import 'package:medimate/view/screen/add_new_medicine/add_new_medicine.dart';
import 'package:medimate/view/screen/home/homepage.dart';
import 'package:medimate/view/screen/welcome_page.dart';
import 'package:medimate/viewmodel/provider/homepage_provider.dart';
import 'package:medimate/viewmodel/provider/medicine_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MedicineProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Popins",
          primaryColor: Color.fromRGBO(7, 190, 200, 1),
          textTheme: TextTheme(
            displayLarge: ThemeData.light().textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 38.0,
                  fontFamily: "Popins",
                ),
            headlineSmall: ThemeData.light().textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 17.0,
                  fontFamily: "Popins",
                ),
            displaySmall: ThemeData.light().textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  fontFamily: "Popins",
                ),
          ),
        ),
        routes: {
          "/": (context) => WelcomePage(),
          "/home": (context) => HomePage(),
          "/add_new_medicine": (context) => AddNewMedicine(),
        },
        initialRoute: "/",
      ),
    );
  }
}
