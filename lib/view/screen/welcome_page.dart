import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.1,
            ),
            Image.asset('assets/images/welcome_image.png',
                width: double.infinity, height: deviceHeight * 0.4),
            SizedBox(
              height: deviceHeight * 0.05,
            ),
            Column(
              children: [
                Container(
                  height: deviceHeight * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: AutoSizeText(
                      "MediMate",
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: Colors.black, height: 1.3),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
                Container(
                  height: deviceHeight * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: AutoSizeText(
                      "An easy-to-use and reliable app that helps you remember to take your meds at the right time",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            Container(
              height: deviceHeight * 0.09,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: FittedBox(
                    child: Text(
                      "Get started now",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
