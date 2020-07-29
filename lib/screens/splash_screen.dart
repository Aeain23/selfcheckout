import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import '../localization/language_constants.dart';
import '../screens/main_screen.dart';

class SplashsScreen extends StatefulWidget {
  @override
  _SplashsScreenState createState() => new _SplashsScreenState();
}

class _SplashsScreenState extends State<SplashsScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          getTranslated(context, "scan_product_barcode_to_start"),
          style: new TextStyle(
              fontSize: 20.0,color: Theme.of(context).textTheme.button.color),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        styleTextUnderTheLoader: new TextStyle(),
        loaderColor: Theme.of(context).textTheme.button.color);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}
