import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/keyboardsetting_screen.dart';
import '../screens/login_screen.dart';
import '../localization/language_constants.dart';
import '../models/location.dart';
import '../providers/connectionprovider.dart';
import '../providers/location_provider.dart';
import '../screens/cloud_screen.dart';
import '../screens/counter_screen.dart';
import '../screens/local_settings_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String selectedVal;
  String branch;

  static const menuItems = <String>[
    'Cloud',
    'Local Settings',
    'Keyboard Settings',
    'Version 1.0.0.2',
  ];
  List<PopupMenuItem<String>> _popupItem = menuItems
      .map(
        (String value) => PopupMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  String getUrl;
  String getReward;
  int getRadio;
  final bool keyboard = false;
  String locationSyskey;
  @override
  void initState() {
    super.initState();
    readLogin();
    saveKeyboard();
  }

  void saveKeyboard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool("keyboard", keyboard);
       print("keyboard in location screen $keyboard");
    });
  }

  clearData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  String locationName;

  void saveBranch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // setState(() {
      sharedPreferences.setString("branch", branch);
      sharedPreferences.setString("locationName", locationName);
      sharedPreferences.setString("locationSyskey", locationSyskey);
      print("location id in location screen $locationSyskey");
    // });
  }

  String username;
  String password;

  readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // setState(() {
      username = preferences.getString("username");
      password = preferences.getString("password");
    // });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context, listen: false);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    return (username != "" && password != "")
        ? SafeArea(
            child: Scaffold(
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
                          } else if (selectedVal == "Keyboard Settings") {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KeyboardSettingScreen()));
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) => _popupItem,
                    )
                  ],
                ),
                body: Center(
                    child: Container(
                  width: 300,
                  height: 300,
                  child: FutureBuilder<LocationData>(
                      future:
                          connectionProvider.checkconnection().then((onValue) {
                        var t;
                        if (onValue) {
                          t = provider.fetchLocation();
                        } else {
                          t = Fluttertoast.showToast(
                            timeInSecForIosWeb: 4,
                            msg: getTranslated(
                                context, "no_internet_connection"),
                          );
                        }
                        return t;
                      }),
                      builder: (context, snapshot) {
                        return snapshot.data != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 300,
                                    height: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      getTranslated(context, "choose_location"),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.blue[900],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            snapshot.data.location.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              branch = snapshot
                                                  .data.location[index].t1;
                                              locationName = snapshot
                                                  .data.location[index].t2;
                                              locationSyskey = snapshot
                                                  .data.location[index].syskey
                                                  .toString();
                                              saveBranch();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CounterScreen(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              color: Colors.grey[300],
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors
                                                            .lightBlue[900],
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(snapshot
                                                            .data
                                                            .location[index]
                                                            .t2),
                                                        height: 70,
                                                      ),
                                                      //
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              )
                            : Center(child: CircularProgressIndicator());
                      }),
                ))))
        : LoginScreen();
  }
}
