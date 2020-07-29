import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/screensize_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/keyboardsetting_screen.dart';
import '../screens/cloud_screen.dart';
import '../screens/local_settings_screen.dart';
import '../localization/language_constants.dart';
import '../providers/login_provider.dart';
import '../screens/main_screen.dart';
import '../models/login.dart';
import '../providers/connectionprovider.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String selectedVal;
  String getUrl;
  String getReward;
  String branch;
  bool getKeyboard;
  String userSyskey;
  String locationSyskey;
  String counterSyskey;
  static const menuItems = <String>[
    'Cloud',
    'Local Settings',
    'Keyboard Settings',
    'Version 1.0.0.3'
  ];
  List<PopupMenuItem<String>> _popupItem = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  TextEditingController userIdController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  TextStyle style = TextStyle(fontSize: 20.0);
  String username;
  String password;
  String userid1;
  String username1;
  void saveLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // setState(() {
    preferences.setString("userid", userid1);
    preferences.setString("username", username1);
    preferences.setString("password", password);
    // });
  }

  String n;
  void saveNoti(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("name", value);
    });
  }

  fetchSystemsetup(Login login) {
    SystemSetup systemSetup = login.systemSetup;
    return systemSetup;
  }

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    _readUrl();
  }

  @override
  void didChangeDependencies() {
    _readUrl();
    super.didChangeDependencies();
  }

  void _readUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getUrl = sharedPreferences.getString("url");
    getReward = sharedPreferences.getString("reward");
    getKeyboard = sharedPreferences.getBool("keyboard");
    locationSyskey = sharedPreferences.getString("locationSyskey");
    counterSyskey = sharedPreferences.getString("counterSyskey");
    print("locid $locationSyskey");
    print("counter sy $counterSyskey");
  }

  void saveBranch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // setState(() {
    sharedPreferences.setString("branch", branch);
    // });
  }

  void saveuserSys() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // setState(() {
    sharedPreferences.setString("userSyskey", userSyskey);
    // });
  }

  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: getTranslated(context, "please_wait"),
      progressWidget: Center(
        child: CircularProgressIndicator(
          valueColor:
              new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    final userid = TextField(
      controller: userIdController,
      style: style,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: getTranslated(context, "user_id"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (value) {
        setState(() {
          username = value;
        });
      },
    );
    final passwordField = TextField(
      controller: pwdController,
      obscureText: true,
      style: style,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: getTranslated(context, "password"),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
    );
    final loginButon = Material(
      child: MaterialButton(
        elevation: 10.0,
        hoverElevation: 10,
        shape: pwdController.text == ""
            ? RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.grey[400]))
            : Theme.of(context).buttonTheme.shape,
        color: Theme.of(context).buttonColor,
       splashColor:Color(0xFFD6914F),
        minWidth: screenSize(context).width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        disabledColor: Colors.grey[400],
        disabledElevation: 10,
        onPressed: userIdController.text == ""
            ? null
            : () {
                connectionProvider.checkconnection().then((onValue) {
                  if (onValue) {
                    dialog.show();
                    print('user name $username');
                    Provider.of<LoginProvider>(context, listen: false)
                        .fetchLogin(
                            username, password, locationSyskey, counterSyskey)
                        .catchError((onError) {
                      Future.delayed(Duration(seconds: 3)).then((value) {
                        dialog.hide().whenComplete(() {
                          Fluttertoast.showToast(
                              msg: getTranslated(
                                  context, "invalid_username_password"),
                              timeInSecForIosWeb: 4);
                        });
                      });
                    }).then((result) {
                      if (result.t2 != null && result.returnMessage == "") {
                        print('successful');
                        userid1 = result.t1;
                        username1 = result.t1;
                        userSyskey = result.syskey;
                        print(userSyskey);
                        saveLogin();
                        saveuserSys();
                        n = json.encode(fetchSystemsetup(result));
                        saveNoti(n);
                        userIdController.clear();
                        pwdController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                        Future.delayed(Duration(seconds: 3)).then((value) {
                          dialog.hide().whenComplete(() {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          });
                        });
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                      timeInSecForIosWeb: 4,
                      msg: getTranslated(context, "no_internet_connection"),
                    );
                  }
                });
              },
        child: Text(getTranslated(context, "login"),
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: userIdController.text == ""
                    ? Color(0xFF41004D)
                    : Theme.of(context).textTheme.button.color,
                fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF41004D),
        backgroundColorEnd: Color(0xFFA5418C),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (newVal) {
              setState(() {
                selectedVal = newVal;
                if (selectedVal == "Cloud") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CloudScreen(),
                    ),
                  );
                } else if (selectedVal == "Local Settings") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LocalSettingsScreen(),
                    ),
                  );
                } else if (selectedVal == 'Keyboard Settings') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => KeyboardSettingScreen(),
                  ));
                }
              });
            },
            itemBuilder: (BuildContext context) => _popupItem,
          )
        ],
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                  child: Text(
                    "Self Checkout",
                    style: TextStyle(
                        fontSize: 30, color: Theme.of(context).buttonColor),
                  ),
                ),
                SizedBox(height: 45.0),
                userid,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
