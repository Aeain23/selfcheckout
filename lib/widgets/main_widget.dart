import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  bool flag = true;
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
      print('hideKeyboard>>$result');
    } on PlatformException catch (e) {
      print("Failed to Invoke Printer: '${e.message}'.");
    }
  }

  void readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      keyboard = preferences.getBool("keyboard");
    });

    //  print("keyboard $keyboard");
  }

  @override
  void didChangeDependencies() {
    readLogin();
    if (keyboard == false) {
      hideKeyboard();
    }
    //  FocusNode currentFocus = FocusScope.of(context);
    //  currentFocus.unfocus();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    connectPrinter();
    readLogin();
    if (keyboard == false) {
      hideKeyboard();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context, listen: true);
    final connectionProvider = Provider.of<ConnectionProvider>(
      context,
    );
    // final providerheader =
    // Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        // FocusNode currentFocus = FocusScope.of(context);

        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBarWidget(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  getTranslated(context, "scan_product_barcode_to_start"),
                  style: TextStyle(
                    fontSize: 22, color: Colors.black,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                stockProvider.getchkdetlsCount() > 0
                    ? Text(
                        getTranslated(context, "itm") +
                            " ${stockProvider.getchkdetlsCount()} " +
                            getTranslated(context, "item_left"),
                        style: TextStyle(
                          fontSize: 16, color: Colors.orange,
                          // fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
                Container(
                    margin: EdgeInsets.only(left: 100),
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.asset("assets/images/barcode_scanner.gif")),
                flag == true
                    ? Opacity(
                        opacity: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: RawKeyboardListener(
                            focusNode: new FocusNode(),
                            autofocus: false,
                            onKey: (RawKeyEvent event) {
                              if (event.runtimeType == RawKeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter) {
                                connectionProvider
                                    .checkconnection()
                                    .then((value) {
                                  if (value) {
                                    if (barcodeController.text != "") {
                                      // String stockBarcode = barcodeController.text;
                                      barcodeController.clear();
                                      // setState(() {
                                      //   flag = false;
                                      // });

                                      Provider.of<StockProvider>(context,
                                              listen: false)
                                          .fetchStockbybarCode(barcode)
                                          .catchError((onError) {
                                        Fluttertoast.showToast(
                                            msg: "Get Stock Error! $onError",
                                            timeInSecForIosWeb: 4);
                                        barcodeController.clear();
                                        FocusScope.of(context)
                                            .requestFocus(focusNode);
                                      }).then((result) {
                                        // setState(() {
                                        //   flag = true;
                                        // });

                                        print(
                                            'result from fetchbybarcode: ${result.chkDtls[0].t3}');
                                        if (result.chkDtls[0].t3 == "") {
                                          Fluttertoast.showToast(
                                              msg: getTranslated(
                                                  context, "invalid_barcode"),
                                              timeInSecForIosWeb: 4);
                                          barcodeController.clear();
                                          FocusScope.of(context)
                                              .requestFocus(focusNode);
                                        } else {
                                          stockProvider.addstocktoList(
                                              result.chkDtls[0]);
                                          barcodeController.clear();
                                          // flag=false;
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StockWidget(result),
                                            ),
                                          );

                                          FocusScope.of(context)
                                              .requestFocus(focusNode);
                                        }
                                      });
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: getTranslated(
                                          context, "no_internet_connection"),
                                    );
                                     barcodeController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(focusNode);
                                  }
                                });
                              }
                            },
                            child: TextFormField(
                              //enabled: false,
                              //readOnly: true,
                              controller: barcodeController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.go,
                              focusNode: focusNode,
                              // autofocus: barcode == null ? false : true,
                              autofocus: true,
                              // decoration: new InputDecoration(
                              //   labelText: 'Enter barcode',
                              //   border: new OutlineInputBorder(
                              //     borderRadius: new BorderRadius.circular(10.0),
                              //   ),
                              // ),
                              onChanged: (value) {
                                setState(() {
                                  barcode = value;
                                  // barcodeController.clear();
                                });
                              },
                              onFieldSubmitted: (value) async {
                                setState(() {
                                  barcode = value;
                                });

                                // Navigator.pop(context, this.barcodeController.text);
                                connectionProvider
                                    .checkconnection()
                                    .then((onValue) {
                                  if (onValue) {
                                    if (barcode != null) {
                                      barcodeController.clear();
                                      // setState(() {
                                      //   flag = false;
                                      // });
                                      Provider.of<StockProvider>(context,
                                              listen: false)
                                          .fetchStockbybarCode(barcode)
                                          .catchError((onError) {
                                        Fluttertoast.showToast(
                                            msg: getTranslated(context,
                                                "cannot_connect_right_now"),
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
                                          FocusScope.of(context)
                                              .requestFocus(focusNode);
                                        } else {
                                          stockProvider.addstocktoList(
                                              result.chkDtls[0]);
                                          barcodeController.clear();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StockWidget(result),
                                            ),
                                          );

                                          FocusScope.of(context)
                                              .requestFocus(focusNode);
                                        }
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(focusNode);
                                    }
                                  } else {
                                    setState(() {
                                      Future.delayed(Duration(seconds: 3))
                                          .then((value) {
                                        Fluttertoast.showToast(
                                            msg: getTranslated(context,
                                                "no_internet_connection"),
                                            timeInSecForIosWeb: 4);
                                        FocusScope.of(context)
                                            .requestFocus(focusNode);
                                      });
                                    });
                                     barcodeController.clear();
                                    FocusScope.of(context)
                                        .requestFocus(focusNode);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
                // Container(
                //   height: MediaQuery.of(context).size.height / 20,
                //   width: MediaQuery.of(context).size.width / 2.6,
                //   decoration: new BoxDecoration(
                //     color: Colors.grey[300],
                //     border: new Border.all(color: Colors.black, width: 1),
                //     borderRadius: new BorderRadius.circular(20.0),
                //   ),
                //   child: FlatButton(
                //     child: Text(getTranslated(context, "next")),
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(
                //           builder: (context) => StockListScreen(),
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),

          //  SizedBox(height: 20),
          //  Container(
          //    height: MediaQuery.of(context).size.height / 16,
          //    width: MediaQuery.of(context).size.width / 3,
          //    decoration: new BoxDecoration(
          //      color: Colors.grey[300],
          //      border: new Border.all(color: Colors.black, width: 1),
          //      borderRadius: new BorderRadius.circular(15.0),
          //    ),
          //    child: FlatButton(
          //      child: Text('Test'),
          //      onPressed: () {
          //        responseFromNativeCode(
          //            data, system, counter, userid, isreprint, macAddress);
          //      },
          //    ),
        ),
      ),
    );
  }
}
