import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';

class KeyboardSettingScreen extends StatefulWidget {
  @override
  _KeyboardSettingScreenState createState() => _KeyboardSettingScreenState();
}

class _KeyboardSettingScreenState extends State<KeyboardSettingScreen> {
  bool value;
  @override
  void initState() {
    readkeyShowHide();
    super.initState();
  }

  readkeyShowHide() async {
    SharedPreferences keyboard = await SharedPreferences.getInstance();
    setState(() {
      value = keyboard.getBool('keyboard');
      print("keyborad hide in sharepreference >> $value");
    });
  }

  savekeyShowHide() async {
    SharedPreferences keyboard = await SharedPreferences.getInstance();
    setState(() {
      keyboard.setBool('keyboard', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "keyboard_settings")),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  getTranslated(context, 'show_keyboard'),
                  style: TextStyle(fontSize: 15),
                )),
            Switch(
              value: this.value != null ? this.value : false,
              onChanged: (bool newValue) {
                setState(() {
                  value = newValue;
                  print("keyboard hide in onChanged >> $value");
                  //save in sharepreference
                  savekeyShowHide();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
