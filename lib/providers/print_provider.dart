import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintProvider with ChangeNotifier {
  static const platform = const MethodChannel('flutter.native/helper');
  String counter, username, macAddress, system;
  String response = "";
  Future<Null> responseFromNativeCode(
    String data,
    String isreprint,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    counter = sharedPreferences.getString("getCounter");
    username = sharedPreferences.getString("username");
    macAddress = sharedPreferences.getString("macAddress");
    system = sharedPreferences.getString("name");

    try {
      final String result = await platform.invokeMethod('helloFromNativeCode', {
        "data": data,
        "system": system,
        "counter": counter,
        "userid": username,
        "isreprint": isreprint,
        "macAddress": macAddress,
      });

      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  }
}
