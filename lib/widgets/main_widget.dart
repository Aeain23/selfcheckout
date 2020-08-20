import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/providers/save_checkheader_provider.dart';
import 'package:self_check_out/screens/login_screen.dart';
import 'package:self_check_out/screens/splash_screen.dart';
import 'package:self_check_out/screensize_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../main.dart';
import '../providers/connectionprovider.dart';
import '../providers/stock_provider.dart';
import '../widgets/stock_widget.dart';
import '../localization/language_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  String barcode;
  TextEditingController barcodeController = new TextEditingController();
  FocusNode focusNode = FocusNode();
  bool keyboard;

  static const platform = const MethodChannel('flutter.native/helper');
  Future<Null> connectPrinter() async {
    try {
      final String result = await platform.invokeMethod('connectPrinter');
      print('Printer>>$result');
    } on PlatformException catch (e) {
      print("Failed to Invoke Printer: '${e.message}'.");
    }
  }

  Future<Null> hideKeyboard() async {
    try {
      final String result = await platform.invokeMethod('hideKeyboard');
      print("double call");
      print('showKeyboard>>$result');
    } on PlatformException catch (e) {
      print("Failed to Invoke Printer: '${e.message}'.");
    }
  }

  void readKeyboardHideShowFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    keyboard = preferences.getBool("keyboard");
    print("keyboard flag in read $keyboard");
    if (keyboard == false) {
      hideKeyboard();
    }
  }

  @override
  void initState() {
    connectPrinter();
    readKeyboardHideShowFlag();
    _readLang();
    readLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    readKeyboardHideShowFlag();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _changeLanguage(String languageCode) async {
    Locale _locale = await setLocale(languageCode);
    MyApp.setLocale(context, _locale);
  }

  String locationSyskey;
  String counterSyskey;
  bool opaValue = true;
  void readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    locationSyskey = preferences.getString("locationSyskey");
    counterSyskey = preferences.getString("counterSyskey");
  }

  void clearData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("userid");
      preferences.remove("username");
      preferences.remove("password");
    });
  }

  String lang;
  _readLang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    lang = pref.getString("languageCode");
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context, listen: true);
    final connectionProvider = Provider.of<ConnectionProvider>(
      context,
    );
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);

    final provider = Provider.of<StockProvider>(context, listen: true);

    if (provider.chkdtlsList.length.toString() != '0') {
      setState(() {
        opaValue = false;
      });
    }
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(flip: false),
              child: Container(
                height: screenHeight(context, dividedBy: 2.5),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [
                      0.1,
                      0.1,
                      0.6,
                      0.9
                    ],
                        colors: [
                      Color(0xFFA5418C),
                      Color(0xFFA5418C),
                      Color(0xFF41004D),
                      Color(0xFF41004D),
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton.icon(
                            shape: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.solidQuestionCircle,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            label: Text(
                              getTranslated(context, "help"),
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                          FlatButton.icon(
                            shape: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.times,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            label: Text(
                              getTranslated(context, "cancel"),
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Provider.of<ConnectionProvider>(context,
                                      listen: false)
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
                                    Provider.of<SaveCheckHeaderProvider>(
                                            context,
                                            listen: false)
                                        .fetchVoidCheckHeader(
                                            providerheader.chkHeader)
                                        .then((onValue1) {
                                      print(onValue1);
                                      provider.removeAll();
                                      providerheader.chkHeader = null;
                                      if (provider.totalAmount == 0.0) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SplashsScreen(),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: getTranslated(
                                          context, "no_internet_connection"),
                                      timeInSecForIosWeb: 4);
                                }
                              });
                            },
                          ),
                          Visibility(
                            visible: opaValue,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  getTranslated(context, "language"),
                                  style: TextStyle(color: Colors.white),
                                ),
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
                              ],
                            ),
                          ),
                          Visibility(
                              visible: opaValue,
                              child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.powerOff,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                onPressed: () {
                                  Widget cancelButton = FlatButton(
                                    shape: InputBorder.none,
                                    child: Text(
                                      getTranslated(context, "cancel"),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  Widget continueButton = FlatButton(
                                    shape: InputBorder.none,
                                    child: Text(getTranslated(context, "ok"),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor)),
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
                                    title: Text(
                                      getTranslated(context, "notice"),
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    content: Text(getTranslated(
                                        context, "do_you_want_to_logout")),
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
                              )),
                        ],
                      ),
                    ),
                    Text(
                      getTranslated(context, "scan_product_barcode_to_start"),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.button.color,
                      ),
                    ),
                    stockProvider.getchkdetlsCount() > 0
                        ? Text(
                            getTranslated(context, "itm") +
                                " ${stockProvider.getchkdetlsCount()} " +
                                getTranslated(context, "item_left"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).textTheme.button.color,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                  width: screenWidth(context, dividedBy: 1),
                  height: screenHeight(context, dividedBy: 1.5),
                  child: Image.asset("assets/images/barcode_scanner_gif.gif")),
            ),
            Opacity(
              opacity: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RawKeyboardListener(
                  focusNode: new FocusNode(),
                  autofocus: false,
                  onKey: (RawKeyEvent event) {
                    if (event.runtimeType == RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter) {
                      connectionProvider.checkconnection().then((value) {
                        if (value) {
                          if (barcodeController.text != "") {
                            barcodeController.clear();
                            stockProvider
                                .fetchStockbybarCode(barcode)
                                .catchError((onError) {
                              Fluttertoast.showToast(
                                  msg: "Get Stock Error! $onError",
                                  timeInSecForIosWeb: 4);
                              barcodeController.clear();
                              FocusScope.of(context).requestFocus(focusNode);
                            }).then((result) {
                              print(
                                  'result from fetchbybarcode: ${result.chkDtls[0].t3}');
                              if (result.chkDtls[0].t3 == "") {
                                Fluttertoast.showToast(
                                    msg: getTranslated(
                                        context, "invalid_barcode"),
                                    timeInSecForIosWeb: 4);
                                barcodeController.clear();
                                FocusScope.of(context).requestFocus(focusNode);
                              } else {
                                stockProvider.addstocktoList(result.chkDtls[0]);
                                barcodeController.clear();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StockWidget(result),
                                  ),
                                );
                                FocusScope.of(context).requestFocus(focusNode);
                              }
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: getTranslated(
                                context, "no_internet_connection"),
                          );
                          barcodeController.clear();
                          FocusScope.of(context).requestFocus(focusNode);
                        }
                      });
                    }
                  },
                  child: TextFormField(
                    controller: barcodeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.go,
                    focusNode: focusNode,
                    autofocus: true,
                    onChanged: (value) {
                      barcode = value;
                    },
                    onFieldSubmitted: (value) async {
                      barcode = value;
                      connectionProvider.checkconnection().then((onValue) {
                        if (onValue) {
                          if (barcode != null) {
                            barcodeController.clear();
                            stockProvider
                                .fetchStockbybarCode(barcode)
                                .catchError((onError) {
                              Fluttertoast.showToast(
                                  msg: "$onError", timeInSecForIosWeb: 4);
                            }).then((result) {
                              print(
                                  'result from fetchbybarcode: ${result.chkDtls[0].t3}');
                              if (result.chkDtls[0].t3 == "") {
                                Fluttertoast.showToast(
                                    msg: getTranslated(
                                        context, "invalid_barcode"),
                                    timeInSecForIosWeb: 4);
                                barcodeController.clear();
                                FocusScope.of(context).requestFocus(focusNode);
                              } else {
                                stockProvider.addstocktoList(result.chkDtls[0]);
                                barcodeController.clear();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StockWidget(result),
                                  ),
                                );

                                FocusScope.of(context).requestFocus(focusNode);
                              }
                            });
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        } else {
                          setState(() {
                            Future.delayed(Duration(seconds: 3)).then((value) {
                              Fluttertoast.showToast(
                                  msg: getTranslated(
                                      context, "no_internet_connection"),
                                  timeInSecForIosWeb: 4);
                              FocusScope.of(context).requestFocus(focusNode);
                            });
                          });
                          barcodeController.clear();
                          FocusScope.of(context).requestFocus(focusNode);
                        }
                      });
                    },
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
