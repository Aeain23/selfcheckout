import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_constants.dart';

class KeyboardSettingScreen extends StatefulWidget {
  @override
  _KeyboardSettingScreenState createState() => _KeyboardSettingScreenState();
}

class _KeyboardSettingScreenState extends State<KeyboardSettingScreen> {
  bool val = false;

  @override
  void initState() {
    super.initState();
    readkeyShowHide();
  }

  @override
  void didChangeDependencies() {
    readkeyShowHide();
    super.didChangeDependencies();
  }

  onSwitchValueChange(bool value) async {
    SharedPreferences keyboard = await SharedPreferences.getInstance();
    setState(() {
      val = value;

      keyboard.setBool('keyboard', val);
    });
    print("keyboard val switch $val");
  }

  readkeyShowHide() async {
    SharedPreferences keyboard = await SharedPreferences.getInstance();
    // setState(() {
      val = keyboard.getBool('keyboard');
    // });
    print("keyboard hide show val switch $val");
  }

  savekeyShowHide() async {
    SharedPreferences keyboard = await SharedPreferences.getInstance();
    setState(() {
      keyboard.setBool('keyboard', val);
    });
    print("keyboard hide show val save switch $val");
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
              value: val,
              onChanged: (newVal) {
                onSwitchValueChange(newVal);
              },
            )
          ],
        ),
      ),
    );
  }
}
