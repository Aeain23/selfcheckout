import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/services.dart';
import '../localization/language_constants.dart';
import '../screens/main_screen.dart';

class SplashsScreen extends StatefulWidget {
  @override
  _SplashsScreenState createState() => new _SplashsScreenState();
}

class _SplashsScreenState extends State<SplashsScreen> {
  static const platform = const MethodChannel('flutter.native/helper');
  Future<Null> hideKeyboard() async {
    try {
      final String result = await platform.invokeMethod('hideKeyboard');
      print('hideKeyboard>>$result');
    } on PlatformException catch (e) {
      print("Failed to Invoke Printer: '${e.message}'.");
    }
  }

  @override
  void initState() {
    hideKeyboard();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    hideKeyboard();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text(
          getTranslated(context, "scan_product_barcode_to_start"),
          style: new TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        loaderColor: Colors.black);
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}
