import 'package:flutter/material.dart';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import '../screensize_reducer.dart';
import '../models/check_header_item.dart';
import '../screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_currency.dart';
import '../models/payment_type.dart';
import '../providers/payment_currency_provider.dart';
import '../providers/payment_type_provider.dart';
import '../localization/language_constants.dart';
import '../models/member_scan.dart';
import '../models/payment_data.dart';
import '../models/promotion_use.dart';
import '../models/t2printData.dart';
import '../providers/connectionprovider.dart';
import '../providers/member_scan_provider.dart';
import '../screens/payment_successful_screen.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/round_slider_track_shape.dart';
import '../providers/card_usage_provider.dart';
import '../providers/save_checkheader_provider.dart';
import '../providers/stock_provider.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class CityCashWidget extends StatefulWidget {
  final double cash;
  final double point;
  final String name;
  final double total;
  final MemberScan memberScan;
  final PromotionUse promotionUse;
  final int couponCount;
  CityCashWidget(
      {this.cash,
      this.point,
      this.name,
      this.total,
      this.memberScan,
      this.promotionUse,
      this.couponCount});
  @override
  _CityCashWidgetState createState() => _CityCashWidgetState();
}

class _CityCashWidgetState extends State<CityCashWidget> {
  var numSeparate;

  double value;
  double remainValue = 0;
  String ref;
  int remainder;
  int max;
  String userid1;
  String password;
  String locationSyskey;
  String counterSyskey;
  String macAddress;
  String cardPreviousBalance = "0";
  String pointPreviousBalance = "0";

  var creditExpirePoint;
  // String creditExpirePoint = "0";
  String cardExpire = "";
  String cardBalance = "0";
  String pointBalance = "0";
  List<PaymentType> payTypeList = [];
  List<Currency> currencyList = [];
  List<PaymentData> paymentdataList = [];
  List<PaymentData> paymentdataListNew = [];
  PaymentData paymentData;
  List<T2pPaymentList> t2pPaymentDataList = [];
  PaymentType paymentType = new PaymentType();
  String cityCashresultRef = "";
  String pointresultRef = "";
  String resultRef = "";

  bool iscontinue = false;

  void readLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid1 = preferences.getString("username");
      password = preferences.getString("password");
      macAddress = preferences.getString("macAddress");
      locationSyskey = preferences.getString("locationSyskey");
      counterSyskey = preferences.getString("counterSyskey");
    });
  }

  String counterNo;
  String locCode;
  void readCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      counterNo = preferences.getString("getCounter");
      locCode = preferences.getString("locationCode");
    });
  }

  // String system;
  // // String branch;
  // void readSystem() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     system = preferences.getString("name");
  //     // branch = preferences.getString("branch");
  //   });
  // }

  @override
  void initState() {
    super.initState();

    value = (widget.total ~/ 100).toDouble();
    if (widget.total.round() < 100) {
      max = 0;
    } else {
      max = (widget.total.round() ~/ 100);
    }

    readLogin();
    readCounter();
    // readSystem();
  }

  String paramPayment;
  // String response = "";
  // static const platform = const MethodChannel('flutter.native/helper');

  // Future<Null> responseFromNativeCode(
  //     String data,
  //     String system,
  //     String counter,
  //     String userid,
  //     String isreprint,
  //     String macAddress) async {
  //   try {
  //     final String result = await platform.invokeMethod('helloFromNativeCode', {
  //       "data": data,
  //       "system": system,
  //       "counter": counter,
  //       "userid": userid,
  //       "isreprint": isreprint,
  //       "macAddress": macAddress,
  //     });

  //     response = result;
  //   } on PlatformException catch (e) {
  //     response = "Failed to Invoke: '${e.message}'.";
  //   }
  // }

  double getCurrencyRate(String cashCode) {
    double cashRate = 0;
    for (int i = 0; i < currencyList.length; i++) {
      if (cashCode == currencyList[i].t1) {
        cashRate = currencyList[i].n2;
      }
    }
    return cashRate;
  }

  ProgressDialog dialog;
  @override
  Widget build(BuildContext context) {
    dialog = new ProgressDialog(context, isDismissible: false);
    dialog.style(
      message: "Please Wait...",
      progressWidget: Center(
        child: CircularProgressIndicator(),
      ),
      insetAnimCurve: Curves.easeInOut,
    );
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final paymentTypeProvider =
        Provider.of<PaymentTypeProvider>(context, listen: false);
    final currencyProvider =
        Provider.of<PaymentCurrencyProvider>(context, listen: false);
    final provider = Provider.of<StockProvider>(context, listen: false);

    paymentTypeProvider.fetchPaymentType().then((result) {
      payTypeList = result;
    });

    currencyProvider.fetchCurrency().then((result) {
      currencyList = result;
    });

    numSeparate = createDisplay(length: 16, separator: ',');
    remainder = provider.totalAmount.round() % 100;

    return Scaffold(
      appBar: AppBarWidget(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset("assets/images/city_reward.jpg"),
                          Text(
                            getTranslated(context, "welcome_back"),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(getTranslated(
                            context, "you_have_in_your_city_rewards_balance")),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(getTranslated(context, "city_cash")),
                            Text(": Ks ${numSeparate(widget.cash.round())}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Text(getTranslated(context, "points")),
                            Text(": ${numSeparate(widget.point.round())}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          getTranslated(context, "total"),
                          style: TextStyle(fontSize: 28, color: Colors.orange),
                        ),
                      ),
                      Text(
                        "Ks ${numSeparate(provider.totalAmount.round())}",
                        style: TextStyle(fontSize: 28, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        getTranslated(context, "payment_by_city_cash"),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Card(
                          color: Colors.white70,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      getTranslated(context, "city_cash"),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor: Colors.orange,
                                            inactiveTrackColor: Colors.orange,
                                            trackShape: RoundSliderTrackShape(
                                                radius: 10),
                                            trackHeight: 13.0,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 12.0),
                                            thumbColor: Colors.grey,
                                            overlayColor: Colors.grey,
                                          ),
                                          child: Slider(
                                            value: value,
                                            min: 0,
                                            max: max.toDouble(),
                                            onChanged: (double newValue) {
                                              setState(() {
                                                value = newValue.roundToDouble();
                                              });

                                              remainValue = (provider
                                                          .totalAmount
                                                          .round() ~/
                                                      100) -
                                                  value.roundToDouble();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      getTranslated(context, "points"),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        "   Ks ${value.round() * 100 + remainder}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        "",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: IconButton(
                                        icon:
                                            Icon(LineAwesomeIcons.plus_circle),
                                        iconSize: 30,
                                        onPressed: value <= 0
                                            ? null
                                            : () {
                                                if (value > 0) {
                                                  print(value);
                                                  print(remainValue);
                                                  setState(() {
                                                    // value -= 1;
                                                    // remainValue += 1;
                                                    value=value.round() - 1.0;
                                                    remainValue=remainValue.round() + 1.0;
                                                  });
                                                }
                                              },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        "${remainValue.round() * 100}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: IconButton(
                                        icon:
                                            Icon(LineAwesomeIcons.minus_circle),
                                        alignment: Alignment.centerLeft,
                                        iconSize: 30,
                                        onPressed: remainValue <= 0
                                            ? null
                                            : () {
                                                 print(value);
                                                  print(remainValue);
                                                if (remainValue > 0) {
                                                  setState(() {
                                                    // remainValue -= 1;
                                                    // value += 1;
                                                    
                                                    remainValue=remainValue.round() - 1.0;
                                                    value=value.round() +1.0;
                                                  });
                                                }
                                              },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        getTranslated(context, "to_be_paid"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "",
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        getTranslated(context, "to_be_used"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 50.0),
            height: screenHeight(context, dividedBy: 16),
            width:screenWidth(context, dividedBy: 2),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(22.0),
                    side: BorderSide(color: Colors.orange)),
                color: Colors.orange,
                child: Text(
                  getTranslated(context, "pay"),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  bool isValid = validation();
                  if (isValid) {
                    Provider.of<ConnectionProvider>(context, listen: false)
                        .checkconnection()
                        .then((onValue) {
                      if (onValue) {
                        dialog.show();
                        int creditamt = widget.total.toInt();

                        if (widget.total < 100) {
                          if (value > 0 && remainValue == 0) {
                            // city cash only
                            value = widget.total;
                            remainValue = 0;
                          } else if (remainValue > 0 && value == 0) {
                            // point only
                            value = 0;
                            remainValue = widget.total;
                          }
                        }
                        value = (value.round() * 100 + remainder).toDouble();
                        remainValue = (remainValue.round() * 100).toDouble();

                        var cardorpoint;
                        var point;
                        bool cardUsageContinue = false;
                        cityCashresultRef = "";
                        pointresultRef = "";

                        for (var i = 0;
                            i < widget.memberScan.cardBalance.length;
                            i++) {
                          if (widget.memberScan.cardBalance[i].creditCode ==
                              "CITYCASH") {
                            cardPreviousBalance =
                                widget.memberScan.cardBalance[i].creditAmount;
                          } else {
                            pointPreviousBalance =
                                widget.memberScan.cardBalance[i].creditAmount;
                            creditExpirePoint = widget
                                .memberScan.cardBalance[i].creditExpireAmount;
                            cardExpire = widget
                                .memberScan.cardBalance[i].creditExpireDate;
                          }
                        }

                        if (value != 0 && remainValue != 0) {
                          cardorpoint = 0;
                          point = 1;

                          Provider.of<CardUsageProvider>(context, listen: false)
                              .fetchCardUsage(
                                  widget.memberScan,
                                  providerheader.chkHeader,
                                  creditamt,
                                  value.round(),
                                  point,
                                  remainValue.round())
                              .catchError((onError) {
                            Future.delayed((Duration(seconds: 2)))
                                .then((value) {
                              dialog.hide().whenComplete(() {
                                Fluttertoast.showToast(
                                    msg: "CardUsage onError! $onError",
                                    timeInSecForIosWeb: 4);
                                Navigator.pop(context);
                              });
                            });
                          }).then((result1) {
                            if (result1.resultCode == "200") {
                              for (var i = 0; i < result1.dd.length; i++) {
                                if (result1.dd[i].type == "Money") {
                                  cardBalance = result1.dd[i].amount;
                                } else {
                                  pointBalance = result1.dd[i].amount;
                                }
                              }

                              T2pPaymentList t2pPaymentData =
                                  new T2pPaymentList(
                                      paymentType: "CITYPOINT",
                                      paidBy: widget.memberScan.cardType,
                                      cardNumber: widget.memberScan.cardNumber,
                                      prevPoint: pointPreviousBalance,
                                      pointBalance: pointBalance,
                                      prevAmt: cardPreviousBalance,
                                      amtBalance: cardBalance);
                              t2pPaymentDataList.add(t2pPaymentData);

                              cardUsageContinue = true;

                              pointresultRef = result1.resultRef;
                            } else if (result1.resultCode == "300" &&
                                result1.resultDesc.contains(
                                    "Duplicate submited RequestNumber")) {
                              cardUsageContinue = true;
                            } else {
                              dialog.hide().whenComplete(() {
                                Fluttertoast.showToast(
                                    msg: "${result1.resultDesc}",
                                    timeInSecForIosWeb: 4);
                                if (result1.resultDesc ==
                                    "This Slip is already paid!") {
                                  provider.chkdtlsList = [];
                                  providerheader.chkHeader = null;
                                  if (provider.totalAmount == 0.0) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => SplashsScreen(),
                                      ),
                                    );
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                                // Navigator.pop(context);
                              });
                            }

                            if (cardUsageContinue) {
                              Provider.of<CardUsageProvider>(context,
                                      listen: false)
                                  .fetchCardUsage(
                                      widget.memberScan,
                                      providerheader.chkHeader,
                                      creditamt,
                                      value.round(),
                                      cardorpoint,
                                      remainValue.round())
                                  .catchError((onError) {
                                Future.delayed((Duration(seconds: 2)))
                                    .then((onValue) {
                                  dialog.hide().whenComplete(() {
                                    Fluttertoast.showToast(
                                        msg: "CardUsage Onerror! $onError",
                                        timeInSecForIosWeb: 4);
                                    Navigator.pop(context);
                                  });
                                });
                              }).then((result) {
                                if (result.resultCode == "200") {
                                  for (var i = 0; i < result.dd.length; i++) {
                                    if (result.dd[i].type == "Money") {
                                      cardBalance = result.dd[i].amount;
                                    } else {
                                      pointBalance = result.dd[i].amount;
                                    }
                                  }

                                  T2pPaymentList t2pPaymentData =
                                      new T2pPaymentList(
                                          paymentType: "CITYCASH",
                                          paidBy: widget.memberScan.cardType,
                                          cardNumber:
                                              widget.memberScan.cardNumber,
                                          prevPoint: pointPreviousBalance,
                                          pointBalance: pointBalance,
                                          prevAmt: cardPreviousBalance,
                                          amtBalance: cardBalance);
                                  t2pPaymentDataList.add(t2pPaymentData);
                                  //cardUsageContinue = true;

                                  cityCashresultRef = result.resultRef;

                                  // if cardusage success for both citycash & point

                                  //  if (t2pPaymentDataList.length >= 2) {
                                  savePaymentProcess();

                                  //  }
                                } else if (result.resultCode == "300" &&
                                    result.resultDesc.contains(
                                        "Duplicate submited RequestNumber")) {
                                  savePaymentProcess();
                                } else {
                                  Future.delayed(Duration(seconds: 2))
                                      .then((onValue) {
                                    dialog.hide().whenComplete(() {
                                      Fluttertoast.showToast(
                                          msg: "${result.resultDesc}",
                                          timeInSecForIosWeb: 4);
                                      if (result.resultDesc ==
                                          "This Slip is already paid!") {
                                        provider.chkdtlsList = [];
                                        providerheader.chkHeader = null;
                                        if (provider.totalAmount == 0.0) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SplashsScreen(),
                                            ),
                                          );
                                        }
                                      } else {
                                        Navigator.pop(context);
                                      }
                                      // Navigator.pop(context);
                                    });
                                  });
                                }
                              });
                            }
                          });
                        }

                        String pType = "";
                        String preCal = "";

                        if (value != 0 && remainValue == 0 ||
                            remainValue != 0 && value == 0) {
                          iscontinue = false;
                          if (value != 0 && remainValue == 0) {
                            cardorpoint = 0;
                            pType = "CITYCASH";
                            preCal = cardPreviousBalance;
                          } else {
                            cardorpoint = 1;
                            pType = "CITYPOINT";
                            preCal = pointPreviousBalance;
                          }
                          //  var bb=json.encode(providerheader.chkHeader);
                          //  print("Card usage provider>>> $bb");
                          Provider.of<CardUsageProvider>(context, listen: false)
                              .fetchCardUsage(
                                  widget.memberScan,
                                  providerheader.chkHeader,
                                  creditamt,
                                  value.round(),
                                  cardorpoint,
                                  remainValue.round())
                              .catchError((onError) {
                            Future.delayed(Duration(seconds: 2))
                                .then((onValue) {
                              dialog.hide().whenComplete(() {
                                print("Onerror rrrrrrrr $onError");
                                Fluttertoast.showToast(
                                    msg: "CardUsage OnError! $onError",
                                    timeInSecForIosWeb: 4);
                                Navigator.pop(context);
                              });
                            });
                          }).then((result) {
                            if (result.resultCode == "200") {
                              for (var i = 0; i < result.dd.length; i++) {
                                if (result.dd[i].type == "Money") {
                                  cardBalance = result.dd[i].amount;
                                } else {
                                  pointBalance = result.dd[i].amount;
                                }
                              }
                              T2pPaymentList t2pPaymentData =
                                  new T2pPaymentList(
                                      paymentType: pType,
                                      paidBy: widget.memberScan.cardType,
                                      cardNumber: widget.memberScan.cardNumber,
                                      prevPoint: preCal,
                                      pointBalance: pointBalance,
                                      prevAmt: preCal,
                                      amtBalance: cardBalance);
                              t2pPaymentDataList.add(t2pPaymentData);
                              iscontinue = true;
                              resultRef = result.resultRef;

                              iscontinue = true;
                            } else if (result.resultCode == "300" &&
                                result.resultDesc.contains(
                                    "Duplicate submited RequestNumber")) {
                              iscontinue = true;
                            } else {
                              Future.delayed(Duration(seconds: 2))
                                  .then((onValue) {
                                Fluttertoast.showToast(
                                    msg: "${result.resultDesc}",
                                    timeInSecForIosWeb: 4);
                                if (result.resultDesc ==
                                    "This Slip is already paid!") {
                                  provider.chkdtlsList = [];
                                  providerheader.chkHeader = null;
                                  if (provider.totalAmount == 0.0) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => SplashsScreen(),
                                      ),
                                    );
                                  }
                                } else {
                                  Navigator.pop(context);
                                }
                                // Navigator.pop(context);
                              });
                            }
                            if (iscontinue) {
                              cashorpointPaymentProcess();
                            }
                          });
                        }
                      } else {
                        dialog.hide().whenComplete(() {
                          Fluttertoast.showToast(
                              msg: getTranslated(
                                  context, "no_internet_connection"),
                              timeInSecForIosWeb: 4);
                        });
                      }
                    });
                  }
                }),
          ),
          SizedBox(width: 20),
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.reply,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _showDialog(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool validation() {
    bool isReturn = true;
    double valueCash = (widget.cash);
    double valuePoint = (widget.point);
    double total = widget.total;

    if (value.round() < 0 || remainValue.round() < 0) {
      isReturn = false;
      Fluttertoast.showToast(
          msg: getTranslated(context, "invalid_amount"), timeInSecForIosWeb: 4);
    }

    if ((valueCash + valuePoint) < total) {
      isReturn = false;
      Fluttertoast.showToast(
          msg: getTranslated(context, "not_enough_amount"),
          timeInSecForIosWeb: 4);
      Navigator.pop(context);
    }
    if (valueCash < (value * 100 + remainder)) {
      isReturn = false;
      _showDialog(getTranslated(context, "city_cash_balance_not_enough"));
      // Fluttertoast.showToast(
      //     msg: getTranslated(context, "not_enough_amount"),
      //     timeInSecForIosWeb: 4);
      // Navigator.pop(context);
    }
    if (valuePoint < remainValue * 100) {
      isReturn = false;
      _showDialog(getTranslated(context, "point_balance_not_enough"));
      // Fluttertoast.showToast(
      //     msg: getTranslated(context, "not_enough_amount"),
      //     timeInSecForIosWeb: 4);
      // Navigator.pop(context);
    }

    return isReturn;
  }

  void savePaymentProcess() {
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final memberprovider =
        Provider.of<MemberScanProvider>(context, listen: false);
    // final printerprovider =
    //     Provider.of<PrintCitycardProvider>(context, listen: false);
    final provider = Provider.of<StockProvider>(context, listen: false);

    // if (t2pPaymentDataList.length >= 2) {
    double cardpoint;
    int i = 0;
    var payTypeCode;
    if (value != 0) {
      i++;
      payTypeList.forEach((value) {
        if (value.t1 == "19") {
          paymentType = value;
        }
      });
      payTypeCode = "19";
      cardpoint = value.round().toDouble();
      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: providerheader.chkHeader.userid,
          username: cityCashresultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: cardpoint,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);

      paymentdataList.add(paymentData);

      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: payTypeCode,
          username: cityCashresultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: cardpoint,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);

      paymentdataListNew.add(paymentData);
    }

    if (remainValue != 0) {
      i++;
      payTypeList.forEach((value) {
        if (value.t1 == "20") {
          paymentType = value;
        }
      });
      payTypeCode = "20";
      cardpoint = remainValue.round().toDouble();
      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: providerheader.chkHeader.userid,
          username: pointresultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: cardpoint,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);
      paymentdataList.add(paymentData);

      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: payTypeCode,
          username: pointresultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: cardpoint,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);
      paymentdataListNew.add(paymentData);
    }

    if (paymentdataList.length > 0) {
      String formattedTime = DateFormat("HHmmss").format(DateTime.now());
      CheckHeader chkHdr = providerheader.chkHeader;
      chkHdr.t11 = formattedTime;
      Provider.of<SavePaymentProvider>(context, listen: false)
          .fetchSavePayment(paymentdataList, chkHdr, provider.getchkdtlsList(),
              widget.memberScan, null)
          .catchError((onError) {
        dialog.hide().whenComplete(() {
          Fluttertoast.showToast(
              msg: "Savepayment error: $onError", timeInSecForIosWeb: 4);
          Navigator.pop(context);
        });
      }).then((onValue) {
        if (onValue != null && onValue.result == "Success") {
          if (providerheader.chkHeader.t15 != "") {
            Provider.of<MemberScanProvider>(context, listen: false)
                .fetchPromotionUseSubmit(
              provider.getchkdtlsList(),
              providerheader.chkHeader,
              widget.memberScan,
              widget.promotionUse.ordervalue,
              widget.promotionUse.promotionvalue,
              null,
              paymentdataList,
              paymentdataListNew,
            )
                .catchError((onError) {
              Future.delayed(Duration(seconds: 2)).then((val) {
                dialog.hide().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "PromotionUse Error : $onError",
                      timeInSecForIosWeb: 4);
                  Navigator.pop(context);
                });
              });
            }).then((onValue) {
              if (onValue.resultCode != "200") {
                Fluttertoast.showToast(
                    msg: getTranslated(
                        context, "PromotionUse : ${onValue.resultDesc}"),
                    timeInSecForIosWeb: 4);
              } else {
                Fluttertoast.showToast(
                    msg: getTranslated(context, "successful"),
                    timeInSecForIosWeb: 4);
              }

              memberprovider
                  .fetchMemberScan(providerheader.chkHeader.t15)
                  .catchError((onError) {
                dialog.hide().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "MemberScan error: $onError", timeInSecForIosWeb: 4);
                  Navigator.pop(context);
                });
              }).then((onResult) {
                Future.delayed(Duration(seconds: 3)).then((val) {
                  dialog.hide().whenComplete(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PaymentSuccessScreen(
                              onResult,
                              value.round(),
                              remainValue.round(),
                              onValue,
                              paymentdataList,
                              t2pPaymentDataList,
                              widget.couponCount,
                              chkHdr)),
                    );
                  });
                });
              });
            });
          }
        } else {
          dialog.hide().whenComplete(() {
            Fluttertoast.showToast(
                msg: "${onValue.result}", timeInSecForIosWeb: 4);
            if (onValue.result == "This Slip is already paid!") {
              provider.chkdtlsList = [];
              providerheader.chkHeader = null;
              if (provider.totalAmount == 0.0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SplashsScreen(),
                  ),
                );
              }
            }
            // else{
            //   Navigator.pop(context);}
          });
        }
      });
    }
  }

  void cashorpointPaymentProcess() {
    final providerheader =
        Provider.of<SaveCheckHeaderProvider>(context, listen: false);
    final memberprovider =
        Provider.of<MemberScanProvider>(context, listen: false);
    // final printerprovider =
    //     Provider.of<PrintCitycardProvider>(context, listen: false);
    final provider = Provider.of<StockProvider>(context, listen: false);

    double cardpoint;
    int i = 0;
    var payTypeCode;
    if (value != 0) {
      i++;
      payTypeList.forEach((value) {
        if (value.t1 == "19") {
          paymentType = value;
        }
      });
      payTypeCode = "19";
      cardpoint = (value.round()).toDouble();
      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: providerheader.chkHeader.userid,
          username: resultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: cardpoint,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);
      paymentdataList.add(paymentData);

      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: payTypeCode,
          username: resultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: cardpoint,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);
      paymentdataListNew.add(paymentData);
    }
    if (remainValue != 0) {
      i++;
      payTypeList.forEach((value) {
        if (value.t1 == "20") {
          paymentType = value;
        }
      });
      payTypeCode = "20";
      cardpoint = remainValue;
      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: providerheader.chkHeader.userid,
          username: resultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: 0.0,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);
      paymentdataList.add(paymentData);

      paymentData = new PaymentData(
          id: "0",
          syskey: 0,
          autokey: 0,
          createddate: providerheader.chkHeader.createddate,
          modifieddate: providerheader.chkHeader.modifieddate,
          userid: payTypeCode,
          username: resultRef,
          territorycode: 0,
          salescode: 0,
          projectcode: 0,
          ref1: 0.0,
          ref2: double.parse(widget.memberScan.cardTypeID),
          ref3: 0.0,
          ref4: 0.0,
          ref5: 0.0,
          ref6: 0.0,
          saveStatus: 8,
          parentid: providerheader.chkHeader.syskey,
          recordStatus: 1,
          syncStatus: 0,
          syncBatch: 0,
          t1: widget.memberScan.cardNumber,
          t2: paymentType.t3,
          n1: payTypeCode,
          n2: i,
          n3: cardpoint,
          n4: getCurrencyRate(paymentType.t3),
          n5: 1,
          n6: 0,
          n7: providerheader.chkHeader.n26,
          n8: "0",
          userSysKey: providerheader.chkHeader.userSysKey,
          t3: providerheader.chkHeader.modifieddate,
          payTypecode: payTypeCode);
      paymentdataListNew.add(paymentData);
    }

    if (paymentdataList.length > 0) {
      String formattedTime = DateFormat("HHmmss").format(DateTime.now());
      CheckHeader chkHdr = providerheader.chkHeader;
      chkHdr.t11 = formattedTime;
      Provider.of<SavePaymentProvider>(context, listen: false)
          .fetchSavePayment(
              paymentdataList,
              chkHdr,
              provider.getchkdtlsList(),
              widget.memberScan,
              // result,
              null)
          .catchError((onError) {
        dialog.hide().whenComplete(() {
          Fluttertoast.showToast(
              msg: "SavePayment error! $onError", timeInSecForIosWeb: 4);
          Navigator.pop(context);
        });
      }).then((onValue) {
        if (onValue != null && onValue.result == "Success") {
          if (providerheader.chkHeader.t15 != "") {
            Provider.of<MemberScanProvider>(context, listen: false)
                .fetchPromotionUseSubmit(
                    provider.getchkdtlsList(),
                    providerheader.chkHeader,
                    widget.memberScan,
                    memberprovider.getOrderValue(),
                    widget.promotionUse.promotionvalue,
                    null,
                    paymentdataList,
                    paymentdataListNew)
                .catchError((onError) {
              dialog.hide().whenComplete(() {
                Fluttertoast.showToast(
                    msg: "PromotionUse  error: $onError",
                    timeInSecForIosWeb: 4);
                Navigator.pop(context);
              });
            }).then((onValue) {
              if (onValue.resultCode != "200") {
                Fluttertoast.showToast(
                    msg: getTranslated(
                        context, "PromotionUse : ${onValue.resultDesc}"),
                    timeInSecForIosWeb: 4);
              } else {
                Fluttertoast.showToast(
                    msg: getTranslated(context, "successful"),
                    timeInSecForIosWeb: 4);
              }

              memberprovider
                  .fetchMemberScan(providerheader.chkHeader.t15)
                  .catchError((onError) {
                dialog.hide().whenComplete(() {
                  Fluttertoast.showToast(
                      msg: "MemberScan error: $onError", timeInSecForIosWeb: 4);
                  Navigator.pop(context);
                });
              }).then((onResult) {
                Future.delayed(Duration(seconds: 3)).then((val) {
                  dialog.hide().whenComplete(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PaymentSuccessScreen(
                              onResult,
                              value.round(),
                              remainValue.round(),
                              onValue,
                              paymentdataList,
                              t2pPaymentDataList,
                              widget.couponCount,
                              chkHdr)),
                    );
                  });
                });
              });
            });
          }
        } else {
          dialog.hide().whenComplete(() {
            Fluttertoast.showToast(
                msg: "${onValue.result}", timeInSecForIosWeb: 4);
            if (onValue.result == "This Slip is already paid!") {
              provider.chkdtlsList = [];
              providerheader.chkHeader = null;
              if (provider.totalAmount == 0.0) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SplashsScreen(),
                  ),
                );
              }
            }
          });
        }
      });
    }
    // }
  }
}
