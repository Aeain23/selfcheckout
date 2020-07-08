import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/screensize_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import '../localization/language_constants.dart';
import '../main.dart';
import '../providers/connectionprovider.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Size(double.infinity, 50);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  void _changeLanguage(String languageCode) async {
    Locale _locale = await setLocale(languageCode);
    MyApp.setLocale(context, _locale);
  }

  String locationSyskey;
  String counterSyskey;
  bool opaValue = true;
  void readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // setState(() {
      locationSyskey = preferences.getString("locationSyskey");
      counterSyskey = preferences.getString("counterSyskey");
    // });
  }

  void clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("userid");
      preferences.remove("username");
      preferences.remove("password");
      // preferences.setString("userid", null);
      // preferences.setString("username", null);
      // preferences.setString("password", null);
    });
  }

  @override
  void initState() {
    _readLang();
    readLogin();
    super.initState();
  }

  String lang;
  _readLang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    lang = pref.getString("languageCode");
  }

  @override
  Widget build(BuildContext context) {
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);

    final provider = Provider.of<StockProvider>(context, listen: true);

    if (provider.chkdtlsList.length.toString() != '0') {
      setState(() {
        opaValue = false;
      });
    }
    return Container(
      width: screenWidthMultiply(context,multiplyBy: 1.5),
      margin: EdgeInsets.only(top: 25),
      color: Colors.white,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Provider.of<ConnectionProvider>(context, listen: false)
                  .checkconnection()
                  .then((onValue) {
                if (onValue) {
                  if (providerheader.chkHeader == null) {
                    print(provider.chkdtlsList.length);
                    provider.removeAll();
                    providerheader.chkHeader = null;
                    if (provider.totalAmount == 0.0) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SplashsScreen(),
                        ),
                      );
                    }
                  } else {
                    Provider.of<SaveCheckHeaderProvider>(context, listen: false)
                        .fetchVoidCheckHeader(providerheader.chkHeader)
                        .then((onValue1) {
                      print(onValue1);
                      provider.removeAll();
                      providerheader.chkHeader = null;
                      if (provider.totalAmount == 0.0) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SplashsScreen(),
                          ),
                        );
                      }
                    });
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: getTranslated(context, "no_internet_connection"),
                      timeInSecForIosWeb: 4);
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  LineAwesomeIcons.close,
                ),
                Text(getTranslated(context, "cancel"))
              ],
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            height: 40,
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.black, width: 1),
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: FlatButton.icon(
              icon: Icon(LineAwesomeIcons.question_circle),
              label: Text(getTranslated(context, "help")),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Visibility(
            visible: opaValue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(getTranslated(context, "language")),
                IconButton(
                    icon: new Image.asset(
                      'assets/images/myanmar_flag.png',
                      scale: 10,
                    ),
                    onPressed: () {
                      if (opaValue) {
                        _changeLanguage("hi");
                      }
                    }),
                IconButton(
                    icon: new Image.asset(
                      'assets/images/eng_flag.png',
                      scale: 10,
                    ),
                    onPressed: () {
                      if (opaValue) {
                        _changeLanguage("en");
                      }
                    }),
                IconButton(
                  icon: Icon(
                    LineAwesomeIcons.sign_out,
                    // color: Colors.black,
                  ),
                  onPressed: () {
                    Widget cancelButton = FlatButton(
                      child: Text(getTranslated(context, "cancel")),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                    Widget continueButton = FlatButton(
                      child: Text(getTranslated(context, "ok")),
                      onPressed: () {
                        provider.removeAll();
                        providerheader.chkHeader = null;
                        clearData();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen()),
                            (r) => false);
                      },
                    );
                    AlertDialog alert = AlertDialog(
                      title: Text(getTranslated(context, "notice")),
                      content:
                          Text(getTranslated(context, "do_you_want_to_logout")),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
