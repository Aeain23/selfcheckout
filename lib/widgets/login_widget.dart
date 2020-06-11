import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
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
  final String locationSk, counterSk;
  LoginWidget(this.locationSk, this.counterSk);
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
  static const menuItems = <String>[
    'Cloud',
    'Local Settings',
    'Keyboard Settings',
    'Version 1.0.0.1'
  ];
  //static const cloudMenuItems = <String>['Demo', 'Domain', 'URL', 'Local'];
  List<PopupMenuItem<String>> _popupItem = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  TextEditingController controller = new TextEditingController();
  TextEditingController controller1 = new TextEditingController();
  TextStyle style = TextStyle(fontSize: 20.0);
  String username;
  String password;
  String userid1;
  String username1;
  void saveLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("userid", userid1);
      preferences.setString("username", username1);
      preferences.setString("password", password);

      preferences.setString("locationSyskey", widget.locationSk);
      preferences.setString("counterSyskey", widget.counterSk);
    });
  }

  String n;
  void saveNoti(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("name", value);
    });
  }

  fetchSystemsetup(Login login) {
    //  var systemsetup =
    //     '{"syskey": "${login.systemSetup.syskey}","autokey":${login.systemSetup.autokey},"createddate": ${login.systemSetup.createddate},"modifieddate": ${login.systemSetup.modifieddate},"userid": "${login.systemSetup.userid}","username": "${login.systemSetup.username}","t1": "${login.systemSetup.t1}","t2": "${login.systemSetup.t2}","t3": "${login.systemSetup.t3}","t4": "${login.systemSetup.t4}","t5": "${login.systemSetup.t5}","t6": ${login.systemSetup.t6},"t7": "${login.systemSetup.t7}", "t8": "${login.systemSetup.t8}","t9": "${login.systemSetup.t9}","t10": "${login.systemSetup.t10}","t11": "${login.systemSetup.t11}","t12": "${login.systemSetup.t12}","t13": "${login.systemSetup.t13}","t14": "${login.systemSetup.t14}", "t15": "${login.systemSetup.t15}","t16": "${login.systemSetup.t16}","t17": "${login.systemSetup.t17}","t18": "${login.systemSetup.t18}","t19": "${login.systemSetup.t19}","t20": "${login.systemSetup.t20}","t21": "${login.systemSetup.t21}","t22": "${login.systemSetup.t22}","t23": "${login.systemSetup.t23}","t24": ${login.systemSetup.t24},"t25": "${login.systemSetup.t25}","t26": ${login.systemSetup.t26},"t27": ${login.systemSetup.t27},"t28": ${login.systemSetup.t28},"t29": ${login.systemSetup.t29}, "t30": ${login.systemSetup.t30}, "n1": ${login.systemSetup.n1},"n2": ${login.systemSetup.n2},"n3": ${login.systemSetup.n3},"n4": ${login.systemSetup.n4},"n5": ${login.systemSetup.n5},"n6": ${login.systemSetup.n6},"n7": ${login.systemSetup.n7},"n8": ${login.systemSetup.n8},"n9": ${login.systemSetup.n9},"n10": ${login.systemSetup.n10},"n11": ${login.systemSetup.n11},"n12": ${login.systemSetup.n12},"n13": ${login.systemSetup.n13},"n14": ${login.systemSetup.n14},"n15": ${login.systemSetup.n15},"t31": "${login.systemSetup.t31}","n16": ${login.systemSetup.n16},"n17": ${login.systemSetup.n17},"n18": ${login.systemSetup.n18},"n19": ${login.systemSetup.n19},"n20": ${login.systemSetup.n20},"n21": ${login.systemSetup.n21},"n22": ${login.systemSetup.n22},"n23": ${login.systemSetup.n23},"n24": ${login.systemSetup.n24},"n25": ${login.systemSetup.n25},"n26": ${login.systemSetup.n26},"n27": ${login.systemSetup.n27},"n28": ${login.systemSetup.n28},"n29": ${login.systemSetup.n29},"n30": ${login.systemSetup.n30}, "t32":"${login.systemSetup.t32}","n31": ${login.systemSetup.n31},"n32": ${login.systemSetup.n32},"n33": ${login.systemSetup.n33},"n34": ${login.systemSetup.n34},"n35": ${login.systemSetup.n35},"n36": ${login.systemSetup.n36}, "n37": ${login.systemSetup.n37},"n38": ${login.systemSetup.n38},"n39": ${login.systemSetup.n39},"n40": ${login.systemSetup.n40},"n41": ${login.systemSetup.n41},"n42": ${login.systemSetup.n42},"n43": ${login.systemSetup.n43},"n44": ${login.systemSetup.n44},"n45": ${login.systemSetup.n45},"n46": ${login.systemSetup.n46},"n47": ${login.systemSetup.n47},"n48": ${login.systemSetup.n48},"n49": ${login.systemSetup.n49},"n50": ${login.systemSetup.n50}, "t33": "${login.systemSetup.t33}","t34": "${login.systemSetup.t34}","t35": "${login.systemSetup.t35}","t36": "${login.systemSetup.t36}","n51": ${login.systemSetup.n51},"t37": "","t38": "${login.systemSetup.t38}","t39": "${login.systemSetup.t39}","t40": "${login.systemSetup.t40}","t41": "${login.systemSetup.t41}","n52": ${login.systemSetup.n52},"n53": ${login.systemSetup.n53},"userSyskey": ${login.systemSetup.userSyskey},"recordStatus": ${login.systemSetup.recordStatus}, "syncBatch": ${login.systemSetup.syncBatch}, "syncStatus": ${login.systemSetup.syncStatus},"o1": ${login.systemSetup.o1}}';
    // return "$systemsetup";
    SystemSetup systemSetup = login.systemSetup;
    return systemSetup;
  }

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    // @override
    // void initState() {
    // super.initState();

    _readUrl();
  }

  @override
  void didChangeDependencies() {
    _readUrl();
    super.didChangeDependencies();
  }

  void _readUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      getUrl = sharedPreferences.getString("url");
      getReward = sharedPreferences.getString("reward");
      getKeyboard = sharedPreferences.getBool("keyboard");
    });
  }

  void saveBranch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("branch", branch);
    });
  }

  void saveuserSys() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("userSyskey", userSyskey);
    });
  }
  // void saveReward() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     sharedPreferences.setString("reward", reward);
  //   });
  // }

  // void _saveUrl() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(
  //     () {
  //       sharedPreferences.setString("url", _url);
  //     },
  //   );
  // }
  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: getTranslated(context, "please_wait"),
      progressWidget: Center(
        child: CircularProgressIndicator(),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    final userid = TextField(
      // obscureText: false,
      controller: controller,
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
      controller: controller1,
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
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          connectionProvider.checkconnection().then((onValue) {
            if (onValue) {
              dialog.show();
              print('user name $username');
              Provider.of<LoginProvider>(context, listen: false)
                  .fetchLogin(
                      username, password, widget.locationSk, widget.counterSk)
                  .catchError((onError) {
                Future.delayed(Duration(seconds: 3)).then((value) {
                  dialog.hide().whenComplete(() {
                    Fluttertoast.showToast(
                        msg:
                            getTranslated(context, "invalid_username_password"),
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
                  controller.clear();
                  controller1.clear();
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
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
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
                    style: TextStyle(fontSize: 30),
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
