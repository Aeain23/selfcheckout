import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:self_check_out/screens/main_screen.dart';
import 'package:self_check_out/screensize_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_button/spring_button.dart';
import '../widgets/stock_widget.dart';
import '../localization/language_constants.dart';
import '../models/check_header_item.dart';
import '../providers/get_checkdetails_provider.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/update_checkdetail_provider.dart';
import '../screens/plastic_bag_screen.dart';
import '../models/check_detail_item.dart';
import '../providers/stock_provider.dart';
import '../providers/connectionprovider.dart';

class StockListWidget extends StatefulWidget {
  @override
  _StockListWidgetState createState() => _StockListWidgetState();
}

class _StockListWidgetState extends State<StockListWidget> {
  var numSeparate;
  int headerSk;
  CheckHeader header;
  String barcode;
  TextEditingController barcodeController = new TextEditingController();
  FocusNode focusNode = FocusNode();
  bool keyboard;
  static const platform = const MethodChannel('flutter.native/helper');

  Future<Null> hideKeyboard() async {
    try {
      final String result = await platform.invokeMethod('hideKeyboard');
      print('showKeyboard>>$result');
    } on PlatformException catch (e) {
      print("Failed to Invoke Printer: '${e.message}'.");
    }
  }

  Future<Null> connectPrinter() async {
    try {
      final String result = await platform.invokeMethod('connectPrinter');
      print('Printer>>$result');
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

  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    numSeparate = createDisplay(
      length: 16,
      separator: ',',
    );
    final stockProvider = Provider.of<StockProvider>(context, listen: true);
    final connectionProvider = Provider.of<ConnectionProvider>(context);
    final savecheckHeaderProvider =
        Provider.of<SaveCheckHeaderProvider>(context, listen: true);
    List<CheckDetailItem> chkdtls = stockProvider.getchkdtlsList();
    final updateCheckDetailProvider =
        Provider.of<UpdateCheckDetailProvider>(context, listen: false);
    final getCheckDetailsProvider =
        Provider.of<GetCheckDetailsProvider>(context, listen: true);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5),
            width: double.infinity,
            height: screenSize(context).height * 2.8 / 4,
            // color: Color(0xFFeceff1),
            child: Scrollbar(
              child: ListView.builder(
                  itemCount: chkdtls.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (chkdtls[index].recordStatus == 4) {
                      return SizedBox();
                    } else {
                      return Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        width: double.infinity,
                        height: screenHeight(context, dividedBy: 7),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/new.png',
                                fit: BoxFit.contain,
                                width: screenWidth(context, dividedBy: 3),
                                height: screenHeight(context, dividedBy: 3),
                              ),
                              Container(
                                width: screenWidth(context, dividedBy: 3),
                                height: screenHeight(context, dividedBy: 3),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(chkdtls[index].t3)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                            icon: const Icon(
                                                FontAwesomeIcons.minusCircle),
                                            color: Color(0xFFA5418C),
                                            // iconSize: Theme.of(context)
                                            //     .iconTheme
                                            //     .size,
                                            onPressed: (chkdtls[index]
                                                            .n8
                                                            .roundToDouble() <=
                                                        1.0 ||
                                                    ((chkdtls[index]
                                                                    .t1
                                                                    .length ==
                                                                13 &&
                                                            chkdtls[index]
                                                                    .t1
                                                                    .substring(
                                                                        0, 2) ==
                                                                "55") ||
                                                        chkdtls[index].n34 ==
                                                            0))
                                                ? null
                                                : () {
                                                    setState(() {
                                                      chkdtls[index]
                                                          .n8 = chkdtls[index]
                                                              .n8
                                                              .roundToDouble() -
                                                          1.0;
                                                      print(
                                                          "qty ${chkdtls[index].n8}");

                                                      double amount = 0;
                                                      double n34Amt = 0;
                                                      print(
                                                          'N19 ${chkdtls[index].n19}');
                                                      if (chkdtls[index].n19 !=
                                                          0) {
                                                        amount = (chkdtls[index]
                                                                    .n14 *
                                                                1) -
                                                            (chkdtls[index]
                                                                    .n19 *
                                                                1);
                                                        n34Amt = (chkdtls[index]
                                                                    .n14 *
                                                                chkdtls[index]
                                                                    .n8) -
                                                            (chkdtls[index]
                                                                    .n19 *
                                                                chkdtls[index]
                                                                    .n8);
                                                      } else {
                                                        amount =
                                                            chkdtls[index].n14 *
                                                                1;
                                                        n34Amt = chkdtls[index]
                                                                .n14 *
                                                            chkdtls[index].n8;
                                                      }
                                                      print('Amount $amount');
                                                      chkdtls[index].n34 =
                                                          n34Amt;
                                                      print(
                                                          "price ${chkdtls[index].n34}");
                                                      stockProvider.total -=
                                                          amount;
                                                    });
                                                  }),
                                        Text(chkdtls[index]
                                            .n8
                                            .toString()
                                            .split('.')
                                            .first),
                                        IconButton(
                                          icon: const Icon(
                                              FontAwesomeIcons.plusCircle),
                                          color: Color(0xFFA5418C),
                                          // iconSize:
                                          // Theme.of(context).iconTheme.size,
                                          onPressed: ((chkdtls[index]
                                                              .t1
                                                              .length ==
                                                          13 &&
                                                      chkdtls[index]
                                                              .t1
                                                              .substring(
                                                                  0, 2) ==
                                                          "55") ||
                                                  chkdtls[index].n34 == 0)
                                              ? null
                                              : () {
                                                  setState(() {
                                                    chkdtls[index]
                                                        .n8 = chkdtls[index]
                                                            .n8
                                                            .roundToDouble() +
                                                        1.0;

                                                    print(
                                                        "qty ${chkdtls[index].n8}");

                                                    double amount = 0;
                                                    double n34Amt = 0;
                                                    print(
                                                        'N19 ${chkdtls[index].n19}');
                                                    if (chkdtls[index].n19 !=
                                                        0) {
                                                      amount = (chkdtls[index]
                                                                  .n14 *
                                                              1) -
                                                          (chkdtls[index].n19 *
                                                              1);
                                                      n34Amt = (chkdtls[index]
                                                                  .n14 *
                                                              chkdtls[index]
                                                                  .n8) -
                                                          (chkdtls[index].n19 *
                                                              chkdtls[index]
                                                                  .n8);
                                                    } else {
                                                      amount =
                                                          chkdtls[index].n14 *
                                                              1;
                                                      n34Amt =
                                                          chkdtls[index].n14 *
                                                              chkdtls[index].n8;
                                                    }
                                                    print('Amount $amount');
                                                    chkdtls[index].n34 = n34Amt;
                                                    print(
                                                        "price ${chkdtls[index].n34}");
                                                    stockProvider.total +=
                                                        amount;
                                                  });
                                                },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: screenHeight(context, dividedBy: 3),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                        icon: const Icon(
                                          Icons.delete_forever,
                                          size: 30,
                                        ),
                                        color: Color(0xFFA5418C),
                                        // iconSize:
                                        // Theme.of(context).iconTheme.size,
                                        onPressed: () async {
                                          dialog = new ProgressDialog(context,
                                              isDismissible: false);
                                          dialog.style(
                                            message: getTranslated(
                                                context, "please_wait"),
                                            progressWidget: Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        Theme.of(context)
                                                            .primaryColor),
                                              ),
                                            ),
                                            insetAnimCurve: Curves.easeInOut,
                                          );
                                          await dialog.show();
                                          Provider.of<ConnectionProvider>(
                                                  context,
                                                  listen: false)
                                              .checkconnection()
                                              .then((onValue) {
                                            if (onValue) {
                                              if (chkdtls[index].syskey ==
                                                  "0") {
                                                savecheckHeaderProvider
                                                    .fetchSaveHeader(
                                                        stockProvider
                                                            .totalAmount,
                                                        stockProvider
                                                            .getchkdtlsList())
                                                    .catchError((onError) {
                                                  setState(() {
                                                    Future.delayed(Duration(
                                                            seconds: 3))
                                                        .then((ca) {
                                                      dialog
                                                          .hide()
                                                          .whenComplete(() {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Save Check Header: $onError");
                                                      });
                                                    });
                                                  });
                                                }).then((value) {
                                                  setState(() {
                                                    stockProvider
                                                        .changeTotalForPromotion(
                                                            value
                                                                .checkDetailItem);
                                                  });

                                                  CheckDetailItem item;
                                                  for (int i = index;
                                                      i <
                                                          value.checkDetailItem
                                                              .length;
                                                      i++) {
                                                    if ((stockProvider
                                                                .getchkdtlsList()[
                                                                    index]
                                                                .t1 ==
                                                            value
                                                                .checkDetailItem[
                                                                    i]
                                                                .t1) &&
                                                        value.checkDetailItem[i]
                                                                .recordStatus !=
                                                            4) {
                                                      item = value
                                                          .checkDetailItem[i];
                                                      i = value.checkDetailItem
                                                          .length;
                                                    }
                                                  }

                                                  CheckHeader header =
                                                      value.checkHeader;
                                                  headerSk = header.syskey;
                                                  item.ref1 = 0;
                                                  item.ref2 = 0;
                                                  item.recordStatus = 4;
                                                  header.n5 =
                                                      header.n5 - item.n34;
                                                  header.n10 = header.n5;
                                                  header.n14 -=
                                                      item.n23.round();
                                                  header.n14.round();
                                                  stockProvider.total -=
                                                      item.n34;
                                                  print(
                                                      "header n5 ${header.n5}");
                                                  updateCheckDetailProvider
                                                      .updateCheckDetailsForDelete(
                                                          header, item)
                                                      .catchError((onError) {
                                                    setState(() {
                                                      Future.delayed(Duration(
                                                              seconds: 3))
                                                          .then((fa) {
                                                        dialog
                                                            .hide()
                                                            .whenComplete(() {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Update Check Detail for delete $onError');
                                                        });
                                                      });
                                                    });
                                                  }).then((value) {
                                                    print("state $value");
                                                    if (value) {
                                                      print(
                                                          "header syskey after update call $headerSk");
                                                      getCheckDetailsProvider
                                                          .getCheckDetailsByParentId(
                                                              headerSk)
                                                          .catchError(
                                                              (onError) {
                                                        setState(() {
                                                          Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          3))
                                                              .then((ha) {
                                                            dialog
                                                                .hide()
                                                                .whenComplete(
                                                                    () {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Get Check Detail for parentId $onError');
                                                            });
                                                          });
                                                        });
                                                      }).then((onValue) {
                                                        stockProvider
                                                            .changeChkdtlsList(
                                                                onValue);
                                                        if (stockProvider
                                                                .getchkdetlsCount() ==
                                                            0) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MainScreen(),
                                                            ),
                                                          );
                                                        } else {
                                                          dialog.hide();
                                                        }
                                                      });
                                                    } else {
                                                      setState(() {
                                                        Future.delayed(Duration(
                                                                seconds: 3))
                                                            .then((pa) {
                                                          dialog
                                                              .hide()
                                                              .whenComplete(() {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Item delete Fail');
                                                          });
                                                        });
                                                      });
                                                    }
                                                  });
                                                });
                                              } else {
                                                savecheckHeaderProvider
                                                    .fetchSaveHeader(
                                                        stockProvider
                                                            .totalAmount,
                                                        stockProvider
                                                            .getchkdtlsList())
                                                    .catchError((onError) {
                                                  setState(() {
                                                    Future.delayed(Duration(
                                                            seconds: 3))
                                                        .then((ta) {
                                                      dialog
                                                          .hide()
                                                          .whenComplete(() {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Get Check Detail for delete $onError');
                                                      });
                                                    });
                                                  });
                                                }).then((value) {
                                                  setState(() {
                                                    stockProvider
                                                        .changeTotalForPromotion(
                                                            value
                                                                .checkDetailItem);
                                                  });

                                                  CheckHeader checkHeader =
                                                      savecheckHeaderProvider
                                                          .getHeader;
                                                  List<CheckDetailItem>
                                                      itemList =
                                                      savecheckHeaderProvider
                                                          .getCheckDetailList;

                                                  var itemindex =
                                                      itemList[index];
                                                  print(
                                                      "Item list of length is :${itemList.length}");
                                                  print(
                                                      "Item index of length:${itemindex.t1}");
                                                  for (int i = 0;
                                                      i < itemList.length;
                                                      i++) {
                                                    if (itemList[i].t1 ==
                                                        itemindex.t1) {
                                                      print(
                                                          "Item list of length: ${itemList.length}");
                                                      print(
                                                          "Item list of index : $index");
                                                      itemList[index].ref1 = 2;
                                                      itemList[index].ref2 =
                                                          int.parse(
                                                              checkHeader.t1);
                                                      itemList[index]
                                                          .recordStatus = 4;
                                                      checkHeader.n5 =
                                                          checkHeader.n5 -
                                                              itemList[index]
                                                                  .n34;
                                                      checkHeader.n10 =
                                                          checkHeader.n5;
                                                      checkHeader.n14 -=
                                                          chkdtls[index].n23;
                                                      checkHeader.n14.round();
                                                    }
                                                  }
                                                  stockProvider.total -=
                                                      itemList[index].n34;
                                                  print(
                                                      "Item list of length: ${itemList.length}");
                                                  print(
                                                      "Item list of index : $index");
                                                  updateCheckDetailProvider
                                                      .updateCheckDetailsForDelete(
                                                          checkHeader,
                                                          itemList[index])
                                                      .catchError((onError) {
                                                    setState(() {
                                                      Future.delayed(Duration(
                                                              seconds: 3))
                                                          .then((ra) {
                                                        dialog
                                                            .hide()
                                                            .whenComplete(() {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Update Check Detail for delete $onError');
                                                        });
                                                      });
                                                    });
                                                  }).then((value) {
                                                    if (value) {
                                                      print(
                                                          "header syskey after update call ${checkHeader.syskey}");
                                                      getCheckDetailsProvider
                                                          .getCheckDetailsByParentId(
                                                              checkHeader
                                                                  .syskey)
                                                          .catchError(
                                                              (onError) {
                                                        setState(() {
                                                          Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          3))
                                                              .then((pa) {
                                                            dialog
                                                                .hide()
                                                                .whenComplete(
                                                                    () {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Get Check Detail for parentid $onError');
                                                            });
                                                          });
                                                        });
                                                      }).then((onValue) {
                                                        stockProvider
                                                            .changeChkdtlsList(
                                                                onValue);
                                                        if (stockProvider
                                                                .getchkdetlsCount() ==
                                                            0) {
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MainScreen(),
                                                            ),
                                                          );
                                                        } else {
                                                          dialog.hide();
                                                        }
                                                      });
                                                    } else {
                                                      setState(() {
                                                        Future.delayed(Duration(
                                                                seconds: 3))
                                                            .then((pa) {
                                                          dialog
                                                              .hide()
                                                              .whenComplete(() {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Item delete Fail');
                                                          });
                                                        });
                                                      });
                                                    }
                                                  });
                                                });
                                              }
                                            } else {
                                              setState(() {
                                                Future.delayed(
                                                        Duration(seconds: 3))
                                                    .then((value) {
                                                  dialog
                                                      .hide()
                                                      .whenComplete(() {
                                                    Fluttertoast.showToast(
                                                        msg: getTranslated(
                                                            context,
                                                            "no_internet_connection"),
                                                        timeInSecForIosWeb: 4);
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            focusNode);
                                                  });
                                                });
                                              });
                                            }
                                          });
                                        }),
                                    Text(
                                      'Ks ${numSeparate(chkdtls[index].n34.round())}',
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            height: screenHeight(context, dividedBy: 16),
            color: Theme.of(context).buttonColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  getTranslated(context, "total"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white),
                ),
                Text(
                  '(${numSeparate(stockProvider.qty.round())}) Qty',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white),
                ),
                Text(
                  'Ks ${numSeparate(stockProvider.total.round())}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            height: screenHeight(context, dividedBy: 17),
            child: Opacity(
              opacity: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
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
                            Provider.of<StockProvider>(context, listen: false)
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
                                barcodeController.clear();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => StockWidget(result),
                                  ),
                                );
                                stockProvider.addstocktoList(result.chkDtls[0]);

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
                      setState(() {
                        barcode = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        barcode = value;
                      });
                      connectionProvider.checkconnection().then((onValue) {
                        if (onValue) {
                          if (barcode != null) {
                            barcodeController.clear();
                            Provider.of<StockProvider>(context, listen: false)
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
                                barcodeController.clear();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => StockWidget(result),
                                  ),
                                );
                                stockProvider.addstocktoList(result.chkDtls[0]);

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
          ),
          Container(
            width: screenWidth(context, dividedBy: 2.6),
            height: screenHeight(context, dividedBy: 18),
            margin: const EdgeInsets.only(bottom: 20),
            // child: RaisedButton(
            //   elevation: 10,
            //   hoverElevation: 10,
            //   splashColor: Color(0xFFD6914F),
            //   highlightColor: Color(0xFFD6914F),
            //   color: Theme.of(context).buttonColor,
            //   shape: Theme.of(context).buttonTheme.shape,
            //   child: Text(
            //     getTranslated(context, "checkout"),
            //     style:
            //         TextStyle(color: Theme.of(context).textTheme.button.color),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => PlasticBagScreen(),
            //       ),
            //     );
            //   },
            // ),
            child: SpringButton(
              SpringButtonType.OnlyScale,
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Text(
                    getTranslated(context, "checkout"),
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlasticBagScreen(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
