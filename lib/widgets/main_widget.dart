import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/screensize_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/connectionprovider.dart';
import '../providers/stock_provider.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/stock_widget.dart';
import '../localization/language_constants.dart';

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

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context, listen: true);
    final connectionProvider = Provider.of<ConnectionProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              getTranslated(context, "scan_product_barcode_to_start"),
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            ),
            stockProvider.getchkdetlsCount() > 0
                ? Text(
                    getTranslated(context, "itm") +
                        " ${stockProvider.getchkdetlsCount()} " +
                        getTranslated(context, "item_left"),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  )
                : Container(),
            Container(
                margin: EdgeInsets.only(left: 100),
                height: screenHeight(context, dividedBy: 4),
                child: Image.asset("assets/images/barcode_scanner.gif")),
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
                      // setState(() {
                      barcode = value;
                      // });
                    },
                    onFieldSubmitted: (value) async {
                      // setState(() {
                      barcode = value;
                      // });
                      connectionProvider.checkconnection().then((onValue) {
                        if (onValue) {
                          if (barcode != null) {
                            barcodeController.clear();
                            stockProvider
                                .fetchStockbybarCode(barcode)
                                .catchError((onError) {
                              Fluttertoast.showToast(
                                  msg: getTranslated(
                                      context, "cannot_connect_right_now"),
                                  timeInSecForIosWeb: 4);
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
